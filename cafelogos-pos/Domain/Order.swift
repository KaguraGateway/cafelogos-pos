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
    private (set) public var payment: Payment?
    private (set) public var orderAt: TimeZone?
    private (set) public var callNumber: UInt?
    
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
        self.init(cart: Cart(), discounts: [], payment: nil, orderAt: nil, callNumber: nil)
    }
    
    public init(cart: Cart, discounts: Array<Discount>, payment: Payment?, orderAt: TimeZone?, callNumber: UInt?) {
        self.init(id: UUID().uuidString, cart: cart, discounts: discounts, payment: payment, orderAt: orderAt, callNumber: callNumber)
    }
    
    public init(id: String, cart: Cart, discounts: Array<Discount>, payment: Payment?, orderAt: TimeZone?, callNumber: UInt?) {
        self.id = id
        self.cart = cart
        self.payment = payment
        self.orderAt = orderAt
        self.discounts = discounts
        self.callNumber = callNumber
    }
    
    mutating func pay(payment: Payment) throws {
        try self.pay(payment: payment, callNumber: nil)
    }
    
    mutating func pay(payment: Payment, callNumber: UInt?) throws {
        if(payment.paymentAmount != totalAmount) {
            throw LogosError.invalidPayment
        }
        if(!payment.isEnoughAmount()) {
            throw LogosError.notEnoughAmount
        }
        self.payment = payment
        self.orderAt = TimeZone.current
        self.callNumber = callNumber
    }
}
