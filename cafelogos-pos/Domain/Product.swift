//
//  Product.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/19.
//

import Foundation

protocol Product {
    var productName: String { get }
    var productId: String { get }
    var isNowSales: Bool { get }
}
