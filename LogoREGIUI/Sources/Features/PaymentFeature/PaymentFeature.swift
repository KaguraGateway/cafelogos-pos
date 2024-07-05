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
        case onDidPayment(Result<NewPaymentOutput, Error>)
        
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
                return .run { [newOrder = state.newOrder, payment = state.payment] send in
                    await send(.onDidPayment(Result {
                        await NewPayment().Execute(payment: payment, postOrder: newOrder)
                    }))
                }
            case let .onDidPayment(.success(result)):
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
                }
                return .none
            default:
                return .none
            }
        }
    }
    
}
