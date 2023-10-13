//
//  GetDiscounts.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import Dependencies

public struct GetDiscounts {
    @Dependency(\.serverDiscountRepository) private var discountRepo;
    
    func Execute() async -> Array<Discount> {
        return await discountRepo.findAll()
    }
}
