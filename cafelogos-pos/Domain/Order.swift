//
//  Order.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation

public struct Order {
    public let id: String
    public var cart: Cart
    public var discounts: Array<Discount>
    private (set) public var payment: OrderPayment?
    private (set) public var orderAt: Date?
    
    public var totalAmount: UInt64 {
        get {
            discounts.reduce(cart.getTotalPrice()) { partialResult, discount in
                if(discount.discountType == DiscountType.price) {
                    return partialResult - UInt64(discount.discountPrice)
                }
                return partialResult
            }
        }
    }
    
    public init() {
        self.init(cart: Cart(), discounts: [], payment: nil)
    }
    
    public init(cart: Cart, discounts: Array<Discount>, payment: OrderPayment?) {
        self.init(id: UUID().uuidString, cart: cart, discounts: discounts, payment: payment, orderAt: Date())
    }
    
    public init(id: String, cart: Cart, discounts: Array<Discount>, payment: OrderPayment?, orderAt: Date?) {
        self.id = id
        self.cart = cart
        self.payment = payment
        self.orderAt = orderAt
        self.discounts = discounts
    }
    
    mutating func pay(payment: OrderPayment) throws {
        if(payment.paymentAmount != totalAmount) {
            throw LogosError.invalidPayment
        }
        if(!payment.isEnoughAmount()) {
            throw LogosError.notEnoughAmount
        }
        self.payment = payment
    }
}
