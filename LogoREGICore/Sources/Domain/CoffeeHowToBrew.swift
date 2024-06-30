//
//  CoffeeHowToBrew.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CoffeeHowToBrew: Codable {
    public let name: String
    public let id: String
    public let beanQuantityGrams: UInt32
    public let amount: UInt64
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(name: String, id: String, beanQuantityGrams: UInt32, amount: UInt64, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.name = name
        self.id = id
        self.beanQuantityGrams = beanQuantityGrams
        self.amount = amount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}
