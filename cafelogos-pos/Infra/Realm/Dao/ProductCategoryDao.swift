//
//  ProductCategoryDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class ProductCategoryDao: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date
}
