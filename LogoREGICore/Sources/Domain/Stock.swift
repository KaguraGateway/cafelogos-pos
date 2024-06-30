//
//  Stock.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Stock: Codable {
    public let name: String
    public let id: String
    public let quantity: Int32
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(name: String, id: String, quantity: Int32, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}
