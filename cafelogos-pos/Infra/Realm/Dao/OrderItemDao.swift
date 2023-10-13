//
//  OrderItemDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class OrderItemDao: Object {
    @Persisted var order: OrderDao?
    @Persisted var product: ProductDao?
    @Persisted var quantity: Int32
    @Persisted var amount: Decimal128
    @Persisted var coffeeBrew: ProductCoffeeBrewDao?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date?
}
