//
//  ProductQueryService.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

public protocol ProductQueryService {
    func fetchProducts() -> Array<ProductCategoryDto>
}
