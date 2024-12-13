//
//  PaymentService.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation

public struct PostPaymentResponse {
    public let callNumber: String?
    public let error: Error?
}

protocol PaymentService {
    func postPayment(payment: Payment, postOrder: Order?, externalPaymentType: String?) async -> PostPaymentResponse
    func updatePayment(payment: Payment) async -> Void
    func getPaymentExternal(paymentId: String) async -> PaymentExternal?
}
