//
//  CoffeeBeans.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CoffeeBean: Codable {
    public let id: String
    public let name: String
    public let gramQuantity: Int32
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(id: String, name: String, gramQuantity: Int32, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.id = id
        self.name = name
        self.gramQuantity = gramQuantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}
