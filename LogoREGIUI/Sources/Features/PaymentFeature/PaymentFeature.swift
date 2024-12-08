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
        
        var isPayButtonEnabled: Bool = true
        
        /**
         * 新しい注文がある場合
         */
        public init(newOrder: Order) {
            self.init(orders: [newOrder])
            self.newOrder = newOrder
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
        }
    }
    
    public enum Action {
        case numericKeyboardAction(NumericKeyboardFeature.Action)
        case alert(PresentationAction<Action.Alert>)
        case onTapPay
        case onTapPayBySquare // FIXME: 外部サービス名がコードに存在してるのはあまりよくないので直したい
        case onDidPayment(Result<NewPaymentOutput, Error>)
        case navigateToSuccess(Payment, [Order], String, UInt32, UInt64)
        
        @CasePathable
        public enum Alert {
            case okTapped
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
                return .none
            case .numericKeyboardAction:
                return .none
            case .onTapPay:
                state.isPayButtonEnabled = false
                return .run { [newOrder = state.newOrder, payment = state.payment] send in
                    await send(.onDidPayment(Result {
                        await NewPayment().Execute(payment: payment, postOrder: newOrder)
                    }))
                }
            case .onTapPayBySquare:
                // FIXME: ちょっとハック感あるので修正
                let totalAmount = PaymentDomainService().getTotalAmount(orders: state.orders)
                state.payment = Payment(type: PaymentType.external, orderIds: state.orders.map { $0.id }, paymentAmount: totalAmount, receiveAmount: totalAmount)
                state.isPayButtonEnabled = false
                return .run { [newOrder = state.newOrder, payment = state.payment] send in
                    await send(.onDidPayment(Result {
                        await NewPayment().Execute(payment: payment, postOrder: newOrder)
                    }))
                }
            case let .onDidPayment(.success(result)):
                state.isPayButtonEnabled = true
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
                    return .send(.navigateToSuccess(state.payment, state.orders, result.callNumber, state.totalQuantity, state.totalAmount))
                }
                return .none
                
            default:
                return .none
            }
        }
    }
    
}
