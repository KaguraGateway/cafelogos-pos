//
//  CustomerDisplayService.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/15.
//

import Foundation

public protocol CustomerDisplayService {
    func updateOrder(orders: [Order])
    func transitionPayment()
    func transitionPaymentSuccess(payment: Payment)
    func updateReceiveAmount(amount: UInt64)
}
