//
//  OrderModel.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@Model
public final class OrderModel {
    @Attribute(.unique) public let id: String
    public let orderAt: Date
    public var syncAt: Date?
    
    public init(id: String, orderAt: Date, syncAt: Date? = nil) {
        self.id = id
        self.orderAt = orderAt
        self.syncAt = syncAt
    }
}

extension OrderModel {
    public func toDomain() -> Order {
        Order(
            id: id,
            cart: Cart(),
            discounts: [],
            orderAt: orderAt
        )
    }
    
    public static func fromDomain(_ domain: Order) -> OrderModel {
        OrderModel(
            id: domain.id,
            orderAt: domain.orderAt,
            syncAt: domain.syncAt
        )
    }
}
