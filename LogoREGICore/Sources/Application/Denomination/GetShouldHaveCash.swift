//
//  GetShouldHaveCash.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/15.
//

import Foundation
import Dependencies

public struct GetShouldHaveCash {
    @Dependency(\.paymentRepository) var paymentRepo
    
    public init() {}
    
    public func Execute() -> UInt64 {
        let payments = paymentRepo.findAllByUnSettled()
        let firstAmount = GetDenominations().Execute();
        return payments.reduce(firstAmount.total(), { prev, payment in
            return prev + payment.paymentAmount
        })
    }
}
