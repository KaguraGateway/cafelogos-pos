//
//  Discount.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation

public enum DiscountType: Int {
    case price = 0
}

public struct Discount {
    public let name: String
    public let id: String
    public let discountType: DiscountType
    public let discountPrice: Int
    
    public init(name: String, id: String, discountType: DiscountType, discountPrice: Int) {
        self.name = name
        self.id = id
        self.discountType = discountType
        self.discountPrice = discountPrice
    }
}
