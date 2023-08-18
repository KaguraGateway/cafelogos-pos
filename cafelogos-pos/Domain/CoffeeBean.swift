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
    public let amountGrams: Int32
    
    public init(id: String, name: String, amountGrams: Int32) {
        self.id = id
        self.name = name
        self.amountGrams = amountGrams
    }
}
