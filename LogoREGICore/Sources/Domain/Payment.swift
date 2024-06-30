//
//  Payment.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation
import ULID

public enum PaymentType: Int {
    case cash = 1
}

public struct Payment {
    public let id: String
    public let type: PaymentType
    public let orderIds: [String]
    public var receiveAmount: UInt64
    public let paymentAmount: UInt64
    public let paymentAt: Date
    public let updatedAt: Date
    public let syncAt: Date?
    
    private var diffAmount: Int {
        get {
            Int(receiveAmount) - Int(paymentAmount)
        }
    }
    
    public var changeAmount: Int {
        get {
            if(diffAmount <= 0) {
                return 0
            }
            return diffAmount
        }
    }
    
    public var shortfallAmount: Int {
        get {
            if(diffAmount >= 0) {
                return 0
            }
            return abs(diffAmount)
        }
    }
    
    public init(type: PaymentType, orderIds: [String], paymentAmount: UInt64, receiveAmount: UInt64) {
        self.init(id: ULID().ulidString, type: type, orderIds: orderIds, paymentAmount: paymentAmount, receiveAmount: receiveAmount, paymentAt: Date(), updatedAt: Date(), syncAt: nil)
    }
    
    public init(id: String, type: PaymentType, orderIds: [String], paymentAmount: UInt64, receiveAmount: UInt64, paymentAt: Date, updatedAt: Date, syncAt: Date?) {
        self.id = id
        self.type = type
        self.orderIds = orderIds
        self.paymentAmount = paymentAmount
        self.receiveAmount = receiveAmount
        self.paymentAt = paymentAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}

public struct PaymentDomainService {
    public init() {}
    
    public func getTotalAmount(orders: [Order]) -> UInt64 {
        return orders.reduce(0, { p, order in
            return p + order.totalAmount
        })
    }

    public func isEnoughAmount(payment: Payment, orders: [Order]) -> Bool {
        let totalAmount = getTotalAmount(orders: orders)
        return payment.receiveAmount >= totalAmount
    }
}

protocol PaymentRepository {
    func findAllByUnSettled() -> [Payment]
    func removeAll() -> Void
    func save(payment: Payment) -> Void
}

