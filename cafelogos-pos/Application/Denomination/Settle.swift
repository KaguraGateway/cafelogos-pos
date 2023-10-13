//
//  Settle.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/07.
//

import Foundation
import Dependencies

public struct Settle {
    @Dependency(\.denominationRepository) private var denominationRepo
    
    func Execute(denominations: Denominations) {
        for denomination in denominations.denominations {
            denominationRepo.save(denomination: denomination)
        }
    }
}
