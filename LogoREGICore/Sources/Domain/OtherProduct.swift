//
//  OtherProduct.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct OtherProduct: Product {
    public let productName: String
    public let productId: String
    public let productCategory: ProductCategory
    public let productType: ProductType
    public let price: UInt64
    public let stock: Stock
    public let isNowSales: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public var syncAt: Date?
    
    public init(productName: String, productId: String, productCategory: ProductCategory, price: UInt64, stock: Stock, isNowSales: Bool, createdAt: Date, updatedAt: Date, syncAt: Date?) {
        self.productName = productName
        self.productId = productId
        self.productCategory = productCategory
        self.productType = ProductType.other
        self.price = price
        self.stock = stock
        self.isNowSales = isNowSales
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
    }
    
    func canBuy() -> Bool {
        // 販売中止中
        if(!self.isNowSales) {
            return false
        }
        // 個数がゼロ個
        if(self.stock.quantity <= 0) {
            return false
        }
        
        return true
    }
}
