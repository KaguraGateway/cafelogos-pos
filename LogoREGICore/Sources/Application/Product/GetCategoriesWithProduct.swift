//
//  GetProducts.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/09.
//

import Foundation
import Dependencies

public struct GetCategoriesWithProduct {
    @Dependency(\.serverProductQS) private var serverProductQS
    
    public init() {}
    
    public func Execute() async -> Array<ProductCatalogDto> {
        return await serverProductQS.fetchProductCategoriesWithProducts()
    }
}
