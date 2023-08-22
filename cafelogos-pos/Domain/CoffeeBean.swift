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
    
    public init(id: String, name: String, gramQuantity: Int32) {
        self.id = id
        self.name = name
        self.gramQuantity = gramQuantity
    }
}
