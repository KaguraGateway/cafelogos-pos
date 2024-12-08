import Foundation

protocol ExternalPaymentService {
    func isExternalPaymentResponse(url: URL) -> Bool
    func handleExternalPaymentResponse(url: URL) -> ExternalPaymentHandleResponseOutput
    func paymentRequest(payment: Payment) -> PaymentRequestOutput
}

public struct PaymentRequestOutput {
    // nilなら成功しているGoスタイル
    public var error: Error?
}

public struct ExternalPaymentHandleResponseOutput {
    // nilなら成功しているGoスタイル
    public var error: Error?
}
