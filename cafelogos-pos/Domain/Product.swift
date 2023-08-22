//
//  Product.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation

public enum ProductType: Int {
    case coffee = 0
    case other = 1
}

protocol Product {
    var productName: String { get }
    var productId: String { get }
    var productCategory: ProductCategory { get }
    var productType: ProductType {get}
    var isNowSales: Bool { get }
}
