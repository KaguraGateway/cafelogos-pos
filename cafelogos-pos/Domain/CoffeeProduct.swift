//
//  Product.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CoffeeProduct: Product {
    public let productName: String
    public let productId: String
    public let productCategory: ProductCategory
    public let productType: ProductType
    public let coffeeBean: CoffeeBean
    public let coffeeHowToBrews: Array<CoffeeHowToBrew>
    public let isNowSales: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(productName: String, productId: String, productCategory: ProductCategory, coffeeBean: CoffeeBean, coffeeHowToBrews: Array<CoffeeHowToBrew>, isNowSales: Bool, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.productName = productName
        self.productId = productId
        self.productCategory = productCategory
        self.productType = ProductType.coffee
        self.coffeeBean = coffeeBean
        self.coffeeHowToBrews = coffeeHowToBrews
        self.isNowSales = isNowSales
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
}
