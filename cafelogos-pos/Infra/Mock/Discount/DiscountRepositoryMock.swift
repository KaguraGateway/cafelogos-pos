//
//  DiscountRepositoryMock.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/23.
//

import Foundation

func initDiscount() -> Discount {
    return Discount(name: "GOGOサザエ割", id: UUID().uuidString, discountType: DiscountType.price, discountPrice: 100, createdAt: Date(), updatedAt: Date(), syncAt: Date())
}

public struct DiscountRepositoryMock: DiscountRepository {
    public func findAll() -> Array<Discount> {
        return [
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
            initDiscount(),
        ]
    }
}
