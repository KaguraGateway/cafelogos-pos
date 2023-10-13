//
//  ProductCategory.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct ProductCategory: Codable {
    public let id: String
    public let name: String
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(id: String, name: String, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}
