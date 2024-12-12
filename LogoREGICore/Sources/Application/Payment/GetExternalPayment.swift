import Foundation
import Dependencies

public struct GetExternalPayment {
    @Dependency(\.serverPaymentService) var paymentService
    
    public init() {}
    
    public func Execute(paymentId: String) async -> PaymentExternal? {
        return await paymentService.getPaymentExternal(paymentId: paymentId)
    }
}
