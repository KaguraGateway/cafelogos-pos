//
//  Cash.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Denomination: Codable {
    public let denomination: UInt16
    public let amount: UInt64
    
    public init(denomination: UInt16, amount: UInt64) {
        self.denomination = denomination
        self.amount = amount
    }
}
