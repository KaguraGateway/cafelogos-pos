//
//  ProductCoffeeBrew.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class ProductCoffeeBrewDao: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var productId: String
    @Persisted var name: String
    @Persisted var beanQuantityGrams: Int32
    @Persisted var amount: Decimal128
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date
}
