//
//  Order.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation
import ULID

public struct Order: Equatable {
    public let id: String
    public var cart: Cart
    public var discounts: Array<Discount>
    private (set) public var orderAt: Date
    public var syncAt: Date?
    
    public var totalAmount: UInt64 {
        get {
            discounts.reduce(cart.getTotalPrice()) { partialResult, discount in
                if(discount.discountType == DiscountType.price) {
                    return partialResult > UInt64(discount.discountPrice) ? partialResult - UInt64(discount.discountPrice) : 0
                }
                return partialResult
            }
        }
    }
    
    public init() {
        self.init(cart: Cart(), discounts: [])
    }
    
    public init(cart: Cart, discounts: Array<Discount>) {
        self.init(id: ULID().ulidString, cart: cart, discounts: discounts, orderAt: Date())
    }
    
    public init(id: String, cart: Cart, discounts: Array<Discount>, orderAt: Date) {
        self.id = id
        self.cart = cart
        self.orderAt = orderAt
        self.discounts = discounts
    }
    
    
    public static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
}

protocol OrderService {
    func getUnpaidOrdersBySeatId(seatId: String) async -> [Order]
}

protocol OrderRepository {
    func save(order: Order)
}


