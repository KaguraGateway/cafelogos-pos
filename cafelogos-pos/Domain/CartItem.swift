//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CartItem {
    public let productId: String
    public let productName: String
    public let productPrice: UInt64
    public var totalPrice: UInt64 {
        get {
            return productPrice * UInt64(quantity)
        }
    }
    private var quantity: UInt32
    public let coffeeHowToBrew: CoffeeHowToBrew?
    
    private let coffeeProduct: CoffeeProduct?
    private let otherProduct: OtherProduct?
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(coffee: CoffeeProduct, brew: CoffeeHowToBrew, quantity: UInt32) throws {
        // 淹れ方として存在するものでなければいけない
        if(!coffee.coffeeHowToBrews.contains(where: { elm in elm.id == brew.id })) {
            throw LogosError.notCanBuy
        }
        
        self.init(productId: coffee.productId, productName: coffee.productName, productPrice: brew.amount, quantity: quantity, coffee: coffee, otherProduct: nil, coffeeHowToBrew: brew, createdAt: Date(), updatedAt: Date(), syncAt: nil)
    }
    
    public init(product: OtherProduct, quantity: UInt32) {
        self.init(productId: product.productId, productName: product.productName, productPrice: product.price, quantity: quantity, coffee: nil, otherProduct: product, coffeeHowToBrew: nil, createdAt: Date(), updatedAt: Date(), syncAt: nil)
    }
    
    private init(productId: String, productName: String, productPrice: UInt64, quantity: UInt32, coffee: CoffeeProduct?, otherProduct: OtherProduct?, coffeeHowToBrew: CoffeeHowToBrew?, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.productId = productId
        self.productName = productName
        self.productPrice = productPrice
        self.quantity = quantity
        self.coffeeProduct = coffee
        self.otherProduct = otherProduct
        self.coffeeHowToBrew = coffeeHowToBrew
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
    
    func canBuy() -> Bool {
        if(self.coffeeProduct != nil && self.coffeeHowToBrew != nil && (self.coffeeHowToBrew!.beanQuantityGrams * self.quantity) <= self.coffeeProduct!.coffeeBean.gramQuantity) {
            return true
        } else if(self.otherProduct != nil && self.otherProduct!.canBuy() && self.otherProduct!.stock.quantity >= self.quantity) {
            return true
        }
        return false
    }
    
    func getQuantity() -> UInt32 {
        return self.quantity
    }
    
    mutating func setQuantity(newQuantity: UInt32) {
        self.quantity = newQuantity
    }
}

extension CartItem: Identifiable {
    public var id: String {
        get {
            if(coffeeProduct != nil && coffeeHowToBrew != nil) {
                return productId + "." + coffeeHowToBrew!.id
            }
            return productId
        }
    }
}
