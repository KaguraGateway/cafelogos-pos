//
//  Denominations.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Denominations: Codable {
    public let denominations: Array<Denomination>
    
    public init(denominations: Array<Denomination>) {
        self.denominations = denominations
    }
    
    func total() -> UInt64 {
        var value: UInt64 = 0
        for denomination in denominations {
            value += UInt64(denomination.denomination) * denomination.amount
        }
        return value
    }
}
