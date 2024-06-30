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
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(amount: UInt16, quantity: UInt64) {
        self.init(amount: amount, quantity: quantity, createdAt: Date(), updatedAt: Date(), syncAt: nil)
    }
    
    public init(amount: UInt16, quantity: UInt64, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.amount = amount
        self.quantity = quantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
    
    public func total() -> UInt64 {
        return UInt64(self.amount) * self.quantity
    }
    
    public mutating func setQuantity(newValue: UInt64) {
        self.quantity = newValue
    }
}

protocol DenominationRepository {
    func findAll() -> Denominations
    func findById(id: String) -> Denomination?
    func save(denomination: Denomination)
}
