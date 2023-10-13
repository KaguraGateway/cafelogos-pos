//
//  Denominations.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Denominations: Codable {
    public var denominations: Array<Denomination>
    
    public init() {
        self.init(denominations: [
            Denomination(amount: 10000, quantity: 0),
            Denomination(amount: 5000, quantity: 0),
            Denomination(amount: 1000, quantity: 0),
            Denomination(amount: 500, quantity: 0),
            Denomination(amount: 100, quantity: 0),
            Denomination(amount: 50, quantity: 0),
            Denomination(amount: 10, quantity: 0),
            Denomination(amount: 5, quantity: 0),
            Denomination(amount: 1, quantity: 0)
        ])
    }
    
    public init(denominations: Array<Denomination>) {
        self.denominations = denominations
    }
    
    func total() -> UInt64 {
        var value: UInt64 = 0
        for denomination in denominations {
            value += denomination.total()
        }
        return value
    }
}
