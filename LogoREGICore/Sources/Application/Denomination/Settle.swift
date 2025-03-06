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
    
    public init() {}
    
    public func Execute(denominations: Denominations) async {
        for denomination in denominations.denominations {
            await denominationRepo.save(denomination: denomination)
        }
        await paymentRepo.removeAll()
    }
}
