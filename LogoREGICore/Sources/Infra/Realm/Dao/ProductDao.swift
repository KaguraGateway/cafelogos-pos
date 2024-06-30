//
//  Product.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

public enum ProductTypeDao: Int, PersistableEnum, CaseIterable {
    case coffee = 0
    case other = 1
}

class ProductDao: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var categoryId: String
    @Persisted var productType: ProductTypeDao
    @Persisted var isNowSales: Bool
    @Persisted var coffeeBeanId: String
    @Persisted var amount: Decimal128
    @Persisted var stockId: String
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date
}
