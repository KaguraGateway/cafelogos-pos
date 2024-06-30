//
//  NewPayment.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import Dependencies

public struct NewPayment {
    @Dependency(\.serverPaymentService) var paymentService
    @Dependency(\.paymentRepository) var paymentRepo
    
    public init() {}
    
    public func Execute(payment: Payment, postOrder: Order?) async -> (callNumber: String, error: Error?) {
        let res = await paymentService.postPayment(payment: payment, postOrder: postOrder)
        if res.error == nil {
            paymentRepo.save(payment: payment)
        }
        return (res.callNumber ?? "", res.error)
    }
}
