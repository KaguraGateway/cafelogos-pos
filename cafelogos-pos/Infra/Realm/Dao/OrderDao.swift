//
//  OrderDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

public enum OrderTypeDaoEnum: Int, PersistableEnum, CaseIterable {
    case EatIn = 0
    case TakeOut = 1
}

class OrderDao: Object {
    @Persisted var id: String
    @Persisted var orderType: OrderTypeDaoEnum
    @Persisted var orderAt: Date
    @Persisted var syncAt: Date
}
