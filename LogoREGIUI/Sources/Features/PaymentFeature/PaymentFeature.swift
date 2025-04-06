import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct PaymentFeature {
    @ObservableState
    public struct State: Equatable {
        var newOrder: Order?
        var orders: [Order]
        var payment: Payment
        let totalQuantity: UInt32
        let totalAmount: UInt64
        
        var numericKeyboardState = NumericKeyboardFeature.State()
        
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var squarePaymentTypeSelector: ConfirmationDialogState<Action.SquarePaymentTypeSelectorDialog>?
        
        var isPayButtonEnabled: Bool = true
        var isServerLoading: Bool = false
        var config: Config
        
        /**
         * 新しい注文がある場合
         */
        public init(newOrder: Order) {
            self.init(orders: [newOrder])
            self.newOrder = newOrder
            self.config = GetConfig().Execute()
        }
        
        /**
         * 注文は済みで、それを精算する場合
         */
        public init(orders: [Order]) {
            self.orders = orders
            self.payment = Payment(type: PaymentType.cash, orderIds: orders.map { $0.id }, paymentAmount: PaymentDomainService().getTotalAmount(orders: orders), receiveAmount: 0)
            self.totalQuantity = orders.reduce(0, { p, order in
                p + order.cart.totalQuantity
            })
            self.totalAmount = PaymentDomainService().getTotalAmount(orders: orders)
            self.numericKeyboardState = NumericKeyboardFeature.State(totalAmount: self.totalAmount)
            self.config = GetConfig().Execute()
        }
    }
    
    public enum Action {
        case numericKeyboardAction(NumericKeyboardFeature.Action)
        case alert(PresentationAction<Action.Alert>)
        case onTapPay
        case onTapPayBySquare
        case onDidPayment(Result<NewPaymentOutput, Error>)
        case navigateToSuccess(Payment, [Order], String, UInt32, UInt64)
        case squarePaymentTypeSelector(PresentationAction<Action.SquarePaymentTypeSelectorDialog>)
        
        @CasePathable
        public enum Alert {
            case okTapped
        }
        @CasePathable
        public enum SquarePaymentTypeSelectorDialog {
            case cardTapped
            case felicaTapped
        }
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.numericKeyboardState, action: \.numericKeyboardAction) {
            NumericKeyboardFeature()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case .numericKeyboardAction(.delegate(.onChangeInputNumeric)):
                state.payment.receiveAmount = state.numericKeyboardState.inputNumeric
                return .run { [amount = state.numericKeyboardState.inputNumeric] _ in
                    @Dependency(\.customerDisplay) var customerDisplay
                    customerDisplay.updateReceiveAmount(amount: amount)
                }
            case .numericKeyboardAction:
                return .none
            case .onTapPay:
                state.isPayButtonEnabled = false
                state.isServerLoading = true
                return .run { [orders = state.orders, newOrder = state.newOrder, payment = state.payment] send in
                    @Dependency(\.customerDisplay) var customerDisplay
                    customerDisplay.updateOrder(orders: orders)
                    customerDisplay.transitionPayment()
                    
                    await send(.onDidPayment(Result {
                        await NewPayment().Execute(payment: payment, postOrder: newOrder, externalPaymentType: nil)
                    }))
                }
            case .onTapPayBySquare:
                state.squarePaymentTypeSelector = .init(title: {
                    TextState("決済手段")
                }, actions: {
                    ButtonState(action: .send(.cardTapped)) {
                        TextState("クレジット決済")
                    }
                    ButtonState(action: .send(.felicaTapped)) {
                        TextState("電子マネー決済")
                    }
                    ButtonState(role: .cancel) {
                        TextState("キャンセル")
                    }
                }, message: {
                    TextState("何で決済するか選択してください")
                })
                return .none
            case .squarePaymentTypeSelector(.dismiss):
                state.squarePaymentTypeSelector = nil
                return .none
            case .squarePaymentTypeSelector(.presented(.cardTapped)):
                state.squarePaymentTypeSelector = nil
                state.isPayButtonEnabled = false
                state.isServerLoading = true
                state.payment = .init(type: .external, orderIds: state.payment.orderIds, paymentAmount: state.payment.paymentAmount, receiveAmount: state.payment.receiveAmount)
                return .run { [newOrder = state.newOrder, payment = state.payment] send in
                    await send(.onDidPayment(Result {
                        let result = await NewPayment().Execute(payment: payment, postOrder: newOrder, externalPaymentType: "CARD_PRESENT")
                        var isSuccess = false
                        while(!isSuccess) {
                            let externalRes = await GetExternalPayment().Execute(paymentId: payment.id)
                            if externalRes != nil && externalRes!.isComplete() {
                                isSuccess = true
                                break
                            }
                            try await Task.sleep(nanoseconds: 500_000_000)
                        }
                        return result
                    }))
                }
            case .squarePaymentTypeSelector(.presented(.felicaTapped)):
                state.squarePaymentTypeSelector = nil
                state.isPayButtonEnabled = false
                state.isServerLoading = true
                state.payment = .init(type: .external, orderIds: state.payment.orderIds, paymentAmount: state.payment.paymentAmount, receiveAmount: state.payment.receiveAmount)
                return .run { [newOrder = state.newOrder, payment = state.payment] send in
                    await send(.onDidPayment(Result {
                        let result = await NewPayment().Execute(payment: payment, postOrder: newOrder, externalPaymentType: "FELICA_ALL")
                        var isSuccess = false
                        while(!isSuccess) {
                            let externalRes = await GetExternalPayment().Execute(paymentId: payment.id)
                            if externalRes != nil && externalRes!.isComplete() {
                                isSuccess = true
                                break
                            }
                            try await Task.sleep(nanoseconds: 500_000_000)
                        }
                        return result
                    }))
                }
            case let .onDidPayment(.success(result)):
                state.isPayButtonEnabled = true
                state.isServerLoading = false
                if result.error != nil {
                    state.alert = AlertState {
                        TextState("サーバーとの通信に失敗しました")
                    } actions: {
                        ButtonState(action: .okTapped) {
                            TextState("OK")
                        }
                    } message: {
                        TextState("お支払いは完了していません。\nやり直してください。\n\(result.error?.localizedDescription ?? "")")
                    }
                } else {
                    print("success")
                    return .run { [payment = state.payment] _ in
                        @Dependency(\.customerDisplay) var customerDisplay
                        customerDisplay.transitionPaymentSuccess(payment: payment)
                    }.concatenate(with: .send(.navigateToSuccess(state.payment, state.orders, result.callNumber, state.totalQuantity, state.totalAmount)))
                }
                return .none
                
            default:
                return .none
            }
        }
    }
    
}
