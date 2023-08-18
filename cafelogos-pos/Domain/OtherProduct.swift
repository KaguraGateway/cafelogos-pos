//
//  OtherProduct.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct OtherProduct: Codable {
    public let productName: String
    public let productId: String
    public let productCategory: ProductCategory
    public let price: UInt64
    public let stock: Stock
    public let isNowSales: Bool
    
    public init(productName: String, productId: String, productCategory: ProductCategory, price: UInt64, stock: Stock, isNowSales: Bool) {
        self.productName = productName
        self.productId = productId
        self.productCategory = productCategory
        self.price = price
        self.stock = stock
        self.isNowSales = isNowSales
    }
    
    func canBuy() -> Bool {
        // 販売中止中
        if(!self.isNowSales) {
            return false
        }
        // 個数がゼロ個
        if(self.stock.amount <= 0) {
            return false
        }
        
        return true
    }
}
