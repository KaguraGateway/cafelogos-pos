//
//  ProductDto.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

public struct CoffeeHowToBrewDto {
    public let name: String
    public let id: String
    public let price: UInt64
    public let beanQuantityGrams: UInt32
    
    public init(name: String, id: String, price: UInt64, beanQuantityGrams: UInt32) {
        self.name = name
        self.id = id
        self.price = price
        self.beanQuantityGrams = beanQuantityGrams
    }
}

public struct CoffeeBeanDto {
    public let id: String
    public let name: String
    public let gramQuantity: Int32
    
    public init(id: String, name: String, gramQuantity: Int32) {
        self.id = id
        self.name = name
        self.gramQuantity = gramQuantity
    }
}

public struct StockDto {
    public let name: String
    public let id: String
    public let quantity: Int32
    
    public init(name: String, id: String, quantity: Int32) {
        self.name = name
        self.id = id
        self.quantity = quantity
    }
}

public struct ProductDto {
    public let productName: String
    public let productId: String
    public let productType: ProductType
    public let amount: UInt64
    public let isNowSales: Bool
    public let stock: StockDto?
    public let coffeeBean: CoffeeBeanDto?
    public let coffeeHowToBrews: Array<CoffeeHowToBrewDto>?
    
    public init(productName: String, productId: String, productType: ProductType, amount: UInt64, isNowSales: Bool, stock: StockDto) {
        self.init(productName: productName, productId: productId, productType: productType, amount: amount, isNowSales: true, stock: stock, coffeeBean: nil, coffeeHowToBrews: nil)
    }
    
    public init(productName: String, productId: String, productType: ProductType, amount: UInt64, isNowSales: Bool, coffeeBean: CoffeeBeanDto?, coffeeHowToBrews: Array<CoffeeHowToBrewDto>?) {
        self.init(productName: productName, productId: productId, productType: productType, amount: amount, isNowSales: true, stock: nil, coffeeBean: coffeeBean, coffeeHowToBrews: coffeeHowToBrews)
    }
    
    public init(productName: String, productId: String, productType: ProductType, amount: UInt64, isNowSales: Bool, stock: StockDto?, coffeeBean: CoffeeBeanDto?, coffeeHowToBrews: Array<CoffeeHowToBrewDto>?) {
        self.productName = productName
        self.productId = productId
        self.productType = productType
        self.amount = amount
        self.isNowSales = isNowSales
        self.stock = stock
        self.coffeeBean = coffeeBean
        self.coffeeHowToBrews = coffeeHowToBrews
    }
}

public struct ProductCategoryDto {
    public let id: String
    public let name: String
    public let products: Array<ProductDto>
    
    public init(id: String, name: String, products: Array<ProductDto>) {
        self.id = id
        self.name = name
        self.products = products
    }
}
