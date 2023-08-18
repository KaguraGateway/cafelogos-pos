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
    public let price: UInt64
    
    public init(name: String, id: String, beanQuantityGrams: UInt32, price: UInt64) {
        self.name = name
        self.id = id
        self.beanQuantityGrams = beanQuantityGrams
        self.price = price
    }
}
