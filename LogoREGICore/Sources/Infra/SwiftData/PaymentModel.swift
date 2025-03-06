//
//  PaymentModel.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@Model
final class PaymentModel {
    @Attribute(.unique) let id: String
    let paymentType: Int
    var receiveAmount: Int64
    let paymentAmount: Int64
    let changeAmount: Int64
    let paymentAt: Date
    var updatedAt: Date
    var syncAt: Date?
    var settleAt: Date?
    
    init(id: String, paymentType: Int, receiveAmount: Int64, paymentAmount: Int64, changeAmount: Int64, paymentAt: Date, updatedAt: Date, syncAt: Date? = nil, settleAt: Date? = nil) {
        self.id = id
        self.paymentType = paymentType
        self.receiveAmount = receiveAmount
        self.paymentAmount = paymentAmount
        self.changeAmount = changeAmount
        self.paymentAt = paymentAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
        self.settleAt = settleAt
    }
}

extension PaymentModel {
    func toDomain() -> Payment {
        Payment(
            id: id,
            type: PaymentType(rawValue: paymentType) ?? .cash,
            orderIds: [],
            paymentAmount: UInt64(paymentAmount),
            receiveAmount: UInt64(receiveAmount),
            paymentAt: paymentAt,
            updatedAt: updatedAt,
            syncAt: syncAt
        )
    }
    
    static func fromDomain(_ domain: Payment) -> PaymentModel {
        PaymentModel(
            id: domain.id,
            paymentType: domain.type.rawValue,
            receiveAmount: Int64(domain.receiveAmount),
            paymentAmount: Int64(domain.paymentAmount),
            changeAmount: Int64(domain.changeAmount),
            paymentAt: domain.paymentAt,
            updatedAt: domain.updatedAt,
            syncAt: domain.syncAt
        )
    }
}
