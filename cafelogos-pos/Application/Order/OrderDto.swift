//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/22.
//

import Foundation

public struct CartItemDto {
    public let productId: String
    public let productName: String
    public let productAmount: UInt64
    public let quantity: UInt32
    public let totalAmount: UInt64
    
    public let coffeeHowToBrew: CoffeeHowToBrewDto?
    
    public init(productId: String, productName: String, productAmount: UInt64, quantity: UInt32, totalAmount: UInt64, coffeeHowToBrew: CoffeeHowToBrewDto?) {
        self.productId = productId
        self.productName = productName
        self.productAmount = productAmount
        self.quantity = quantity
        self.totalAmount = totalAmount
        self.coffeeHowToBrew = coffeeHowToBrew
    }
}

public struct CartDto {
    public let items: Array<CartItemDto>
    public let totalQuantity: UInt32
    
    public init(items: Array<CartItemDto>, totalQuantity: UInt32) {
        self.items = items
        self.totalQuantity = totalQuantity
    }
}
