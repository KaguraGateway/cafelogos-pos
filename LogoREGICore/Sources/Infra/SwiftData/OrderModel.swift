//
//  OrderModel.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@Model
final class OrderModel {
    @Attribute(.unique) let id: String
    let orderAt: Date
    var syncAt: Date?
    
    init(id: String, orderAt: Date, syncAt: Date? = nil) {
        self.id = id
        self.orderAt = orderAt
        self.syncAt = syncAt
    }
}

extension OrderModel {
    func toDomain() -> Order {
        Order(
            id: id,
            cart: Cart(),
            discounts: [],
            orderAt: orderAt
        )
    }
    
    static func fromDomain(_ domain: Order) -> OrderModel {
        OrderModel(
            id: domain.id,
            orderAt: domain.orderAt,
            syncAt: domain.syncAt
        )
    }
}
