import Foundation

public struct PaymentExternal: Equatable {
    public let id: String
    public let paymentId: String
    public let paymentType: String
    public let status: String
    public let externalServiceId: String
    public let externalDeviceId: String
    public let createdAt: Date
    public let updatedAt: Date
    public let paidAt: Date?
    
    public init(id: String, paymentId: String, paymentType: String, status: String, externalServiceId: String, externalDeviceId: String, createdAt: Date, updatedAt: Date, paidAt: Date?) {
        self.id = id
        self.paymentId = paymentId
        self.paymentType = paymentType
        self.status = status
        self.externalServiceId = externalServiceId
        self.externalDeviceId = externalDeviceId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.paidAt = paidAt
    }
    
    public func isComplete() -> Bool {
        status == "COMPLETED"
    }
}
