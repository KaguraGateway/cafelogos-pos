//
//  Denomination.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class DenominationDao: Object {
    @Persisted(primaryKey: true) var denomination: Int
    @Persisted var amount: Decimal128
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date?
}
