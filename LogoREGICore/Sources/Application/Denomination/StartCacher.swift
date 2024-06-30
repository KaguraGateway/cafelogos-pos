//
//  StartCacher.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import Dependencies

public struct StartCacher {
    @Dependency(\.denominationRepository) private var denominationRepo
    
    public init() {}
    
    public func Execute(denominations: Denominations) {
        for denomination in denominations.denominations {
            denominationRepo.save(denomination: denomination)
        }
    }
}
