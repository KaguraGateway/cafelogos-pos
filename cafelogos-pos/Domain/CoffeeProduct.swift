//
//  Product.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct CoffeeProduct: Codable {
    public let productName: String
    public let productId: String
    public let coffeeBean: CoffeeBean
    public let coffeeHowToBrews: Array<CoffeeHowToBrew>
    public let isNowSales: Bool
    
    public init(productName: String, productId: String, coffeeBean: CoffeeBean, coffeeHowToBrews: Array<CoffeeHowToBrew>, isNowSales: Bool) {
        self.productName = productName
        self.productId = productId
        self.coffeeBean = coffeeBean
        self.coffeeHowToBrews = coffeeHowToBrews
        self.isNowSales = isNowSales
    }
}
