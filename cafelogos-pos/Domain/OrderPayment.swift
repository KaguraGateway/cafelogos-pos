//
//  Payment.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation

public enum PaymentType: Int {
    case cash = 1
}

public struct OrderPayment {
    public let id: String
    public let type: PaymentType
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
    
    public init(type: PaymentType, paymentAmount: UInt64, receiveAmount: UInt64) {
        self.init(id: UUID().uuidString, type: type, paymentAmount: paymentAmount, receiveAmount: receiveAmount, paymentAt: Date(), updatedAt: Date(), syncAt: nil)
    }
    
    public init(id: String, type: PaymentType, paymentAmount: UInt64, receiveAmount: UInt64, paymentAt: Date, updatedAt: Date, syncAt: Date?) {
        self.id = id
        self.type = type
        self.paymentAmount = paymentAmount
        self.receiveAmount = receiveAmount
        self.paymentAt = paymentAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
    
    func isEnoughAmount() -> Bool {
        return receiveAmount >= paymentAmount
    }
}
