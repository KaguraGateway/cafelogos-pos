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
    public let createdAt: Date
    public let updatedAt: Date
    public let syncAt: Date

    public init(name: String, id: String, discountType: DiscountType, discountPrice: Int, createdAt: Date, updatedAt: Date, syncAt: Date) {
        self.name = name
        self.id = id
        self.discountType = discountType
        self.discountPrice = discountPrice
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}

public protocol DiscountRepository {
    func findAll() -> Array<Discount>
}
