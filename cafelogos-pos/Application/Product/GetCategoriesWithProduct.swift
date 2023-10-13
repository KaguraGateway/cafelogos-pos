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
    
    func Execute() async -> Array<ProductCategoryWithProductsDto> {
        return await serverProductQS.fetchProductCategoriesWithProducts()
    }
}
