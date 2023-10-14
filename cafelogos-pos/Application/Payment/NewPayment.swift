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
    
    func Execute(payment: Payment, postOrder: Order?) async -> (callNumber: String, error: Error?) {
        let res = await paymentService.postPayment(payment: payment, postOrder: postOrder)
        return (res.callNumber ?? "", res.error)
    }
}
