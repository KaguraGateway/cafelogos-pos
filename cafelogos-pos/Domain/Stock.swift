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
    public let amount: Int32
    
    public init(name: String, id: String, amount: Int32) {
        self.name = name
        self.id = id
        self.amount = amount
    }
}