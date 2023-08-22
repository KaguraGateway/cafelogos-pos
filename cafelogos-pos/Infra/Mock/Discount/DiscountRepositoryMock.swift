//
//  DiscountRepositoryMock.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/23.
//

import Foundation

public struct DiscountRepositoryMock: DiscountRepository {
    public func findAll() -> Array<Discount> {
        return [
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
            Discount(name: "新入生割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100),
        ]
    }
}
