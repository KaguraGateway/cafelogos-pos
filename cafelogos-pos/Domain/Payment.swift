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

public struct Payment {
    public let id: String
    public let type: PaymentType
    public var receiveAmount: UInt64
    public let paymentAmount: UInt64
    
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
        self.init(id: UUID().uuidString, type: type, paymentAmount: paymentAmount, receiveAmount: receiveAmount)
    }
    
    public init(id: String, type: PaymentType, paymentAmount: UInt64, receiveAmount: UInt64) {
        self.id = id
        self.type = type
        self.paymentAmount = paymentAmount
        self.receiveAmount = receiveAmount
    }
    
    func isEnoughAmount() -> Bool {
        return receiveAmount >= paymentAmount
    }
}
