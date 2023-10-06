//
//  Discount.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

public enum DiscountTypeEnumDao: Int, PersistableEnum, CaseIterable {
    case PRICE = 0
}

class DiscountDao: Object {
    @Persisted var id: String
    @Persisted var discountType: DiscountTypeEnumDao
    @Persisted var discountPrice: Decimal128
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date?
}
