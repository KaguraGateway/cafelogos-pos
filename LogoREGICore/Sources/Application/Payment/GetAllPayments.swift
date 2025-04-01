//
//
//

import Foundation
import Dependencies

public struct GetAllPayments {
    @Dependency(\.paymentRepository) var paymentRepo
    
    public init() {}
    
    public func Execute() -> [Payment] {
        return paymentRepo.findAll()
    }
}
