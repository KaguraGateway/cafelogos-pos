import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct PaymentListFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var payments: [Payment] = []
        // 決済ID -> チケット番号
        var ticketNumberMap: [String: [String]] = [:]
        var isLoading: Bool = false
        var cancelingPaymentId: String? = nil

        public init() {}
    }

    public enum Action {
        case onAppear
        case loadPayments
        case paymentsLoaded([Payment], [String: [String]])
        case cancelButtonTapped(Payment)
        case cancelPayment(String)
        case cancelPaymentResponse(CancelPaymentError?)
        case alert(PresentationAction<Alert>)

        @CasePathable
        public enum Alert: Equatable {
            case confirmCancelTapped(String)
        }
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadPayments)

            case .loadPayments:
                state.isLoading = true
                let payments = GetAllPayments().Execute()
                // TODO: 決済とチケットの紐付けが未実装のため、常に空。
                // TicketにpaymentIdを持たせるか、決済保存時にチケット番号を保存する必要がある
                let ticketMap: [String: [String]] = [:]
                return .send(.paymentsLoaded(payments, ticketMap))

            case let .paymentsLoaded(payments, ticketMap):
                state.payments = payments
                state.ticketNumberMap = ticketMap
                state.isLoading = false
                return .none

            case let .cancelButtonTapped(payment):
                state.alert = AlertState {
                    TextState("この取引を取り消しますか？")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmCancelTapped(payment.id)) {
                        TextState("取消する")
                    }
                    ButtonState(role: .cancel) {
                        TextState("戻る")
                    }
                } message: {
                    TextState("""
                    オーダー番号: \(payment.callNumbers.isEmpty ? "-" : payment.callNumbers.joined(separator: ", "))
                    支払額: ¥\(payment.paymentAmount)
                    日時: \(formatDate(payment.paymentAt))

                    取り消した取引は元に戻せません。お客様への返金を行ってください。
                    """)
                }
                return .none

            case let .alert(.presented(.confirmCancelTapped(paymentId))):
                state.alert = nil
                return .send(.cancelPayment(paymentId))

            case .alert:
                return .none

            case let .cancelPayment(paymentId):
                state.cancelingPaymentId = paymentId
                return .run { send in
                    let error = await CancelPayment().Execute(paymentId: paymentId)
                    await send(.cancelPaymentResponse(error))
                }

            case let .cancelPaymentResponse(error):
                state.cancelingPaymentId = nil
                if let error {
                    state.alert = AlertState {
                        TextState("取消に失敗しました")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("OK")
                        }
                    } message: {
                        TextState(errorMessage(error))
                    }
                    return .none
                }
                return .send(.loadPayments)
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }

    private func errorMessage(_ error: CancelPaymentError) -> String {
        switch error {
        case .notFound:
            return "対象の取引が見つかりませんでした。"
        case .alreadyCanceled:
            return "この取引はすでに取消済みです。"
        case .unsupportedPaymentType:
            return "現金以外の決済はPOSから取消できません。Square端末で返金してください。"
        case let .serverError(message):
            return "サーバーとの通信に失敗しました。取引は取り消されていません。\n\(message)"
        }
    }
}
