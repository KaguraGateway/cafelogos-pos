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
    @Dependency(\.paymentRepository) private var paymentRepo
    
    func Execute(denominations: Denominations) {
        for denomination in denominations.denominations {
            denominationRepo.save(denomination: denomination)
        }
        paymentRepo.removeAll()
    }
}
