//
//  OrderDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class OrderDao: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var orderAt: Date
    @Persisted var syncAt: Date?
}
