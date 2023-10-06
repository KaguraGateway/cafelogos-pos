//
//  OrderDiscountDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class OrderDiscountDao: Object {
    @Persisted var id: String
    @Persisted var order: OrderDao
    @Persisted var discount: DiscountDao
    @Persisted var syncAt: Date?
}
