//
//  ProductDto.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

public struct CoffeeHowToBrewDto: Equatable {
    public let name: String
    public let id: String
    public let amount: UInt64
    public let beanQuantityGrams: UInt32
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(name: String, id: String, amount: UInt64, beanQuantityGrams: UInt32, createdAt: Date, updatedAt: Date) {
        self.name = name
        self.id = id
        self.amount = amount
        self.beanQuantityGrams = beanQuantityGrams
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct CoffeeBeanDto: Equatable {
    public let id: String
    public let name: String
    public let gramQuantity: Int32
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, gramQuantity: Int32, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.gramQuantity = gramQuantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct StockDto: Equatable {
    public let name: String
    public let id: String
    public let quantity: Int32
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(name: String, id: String, quantity: Int32, createdAt: Date, updatedAt: Date) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct ProductDto: Equatable {
    public let productName: String
    public let productId: String
    public let productCategory: ProductCategoryDto
    public let productType: ProductType
    public let amount: UInt64
    public let isNowSales: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let stock: StockDto?
    public let coffeeBean: CoffeeBeanDto?
    public let coffeeHowToBrews: Array<CoffeeHowToBrewDto>?
    
    public init(productName: String, productId: String, productCategory: ProductCategoryDto, productType: ProductType, amount: UInt64, isNowSales: Bool, createdAt: Date, updatedAt: Date, stock: StockDto) {
        self.init(productName: productName, productId: productId, productCategory: productCategory, productType: productType, amount: amount, isNowSales: true, createdAt: createdAt, updatedAt: updatedAt, stock: stock, coffeeBean: nil, coffeeHowToBrews: nil)
    }
    
    public init(productName: String, productId: String, productCategory: ProductCategoryDto, productType: ProductType, amount: UInt64, isNowSales: Bool, createdAt: Date, updatedAt: Date, coffeeBean: CoffeeBeanDto?, coffeeHowToBrews: Array<CoffeeHowToBrewDto>?) {
        self.init(productName: productName, productId: productId, productCategory: productCategory, productType: productType, amount: amount, isNowSales: true, createdAt: createdAt, updatedAt: updatedAt, stock: nil, coffeeBean: coffeeBean, coffeeHowToBrews: coffeeHowToBrews)
    }
    
    public init(productName: String, productId: String, productCategory: ProductCategoryDto, productType: ProductType, amount: UInt64, isNowSales: Bool, createdAt: Date, updatedAt: Date, stock: StockDto?, coffeeBean: CoffeeBeanDto?, coffeeHowToBrews: Array<CoffeeHowToBrewDto>?) {
        self.productName = productName
        self.productId = productId
        self.productCategory = productCategory
        self.productType = productType
        self.amount = amount
        self.isNowSales = isNowSales
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.stock = stock
        self.coffeeBean = coffeeBean
        self.coffeeHowToBrews = coffeeHowToBrews
    }
}

public struct ProductCategoryDto: Equatable {
    public let id: String
    public let name: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


public struct ProductCatalogDto: Equatable {
    public let id: String
    public let name: String
    public let products: Array<ProductDto>
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, createdAt: Date, updatedAt: Date, products: Array<ProductDto>) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.products = products
    }
}
