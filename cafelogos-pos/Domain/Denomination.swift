//
//  Cash.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//
import Foundation

public struct Denomination: Codable {
    public let amount: UInt16
    public var quantity: UInt64
    
    public init(amount: UInt16, quantity: UInt64) {
        self.amount = amount
        self.quantity = quantity
    }
    
    func total() -> UInt64 {
        return UInt64(self.amount) * self.quantity
    }
    
    mutating func setQuantity(newValue: UInt64) {
        self.quantity = newValue
    }
}
