//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CartItem: Codable {
    public let productId: String
    public let productName: String
    public let productPrice: UInt64
    public var totalPrice: UInt64 {
        get {
            return productPrice * UInt64(amount)
        }
    }
    private var amount: UInt32
    public let coffeeHowToBrew: CoffeeHowToBrew?
    
    private let coffeeProduct: CoffeeProduct?
    private let otherProduct: OtherProduct?
    
    public init(coffee: CoffeeProduct, brew: CoffeeHowToBrew, amount: UInt32) throws {
        // 淹れ方として存在するものでなければいけない
        if(!coffee.coffeeHowToBrews.contains(where: { elm in elm.id == brew.id })) {
            throw LogosError.notCanBuy
        }
        
        self.init(productId: coffee.productId, productName: coffee.productName, productPrice: brew.price, amount: amount, coffee: coffee, otherProduct: nil, coffeeHowToBrew: brew)
    }
    
    public init(product: OtherProduct, amount: UInt32) {
        self.init(productId: product.productId, productName: product.productName, productPrice: product.price, amount: amount, coffee: nil, otherProduct: product, coffeeHowToBrew: nil)
    }
    
    private init(productId: String, productName: String, productPrice: UInt64, amount: UInt32, coffee: CoffeeProduct?, otherProduct: OtherProduct?, coffeeHowToBrew: CoffeeHowToBrew?) {
        self.productId = productId
        self.productName = productName
        self.productPrice = productPrice
        self.amount = amount
        self.coffeeProduct = coffee
        self.otherProduct = otherProduct
        self.coffeeHowToBrew = coffeeHowToBrew
    }
    
    func canBuy() -> Bool {
        if(self.coffeeProduct != nil && self.coffeeHowToBrew != nil && (self.coffeeHowToBrew!.beanQuantityGrams * self.amount) <= self.coffeeProduct!.coffeeBean.amountGrams) {
            return true
        } else if(self.otherProduct != nil && self.otherProduct!.canBuy() && self.otherProduct!.stock.amount >= self.amount) {
            return true
        }
        return false
    }
    
    func getAmount() -> UInt32 {
        return self.amount
    }
    
    mutating func setAmount(newAmount: UInt32) {
        self.amount = newAmount
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