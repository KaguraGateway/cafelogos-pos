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
    
    public func Execute() async -> UInt64 {
        let payments = paymentRepo.findAllByUnSettled()
        let firstAmount = await GetDenominations().Execute()
        return payments.reduce(firstAmount.total()) { prev, payment in
            prev + payment.paymentAmount
        }
    }
}
