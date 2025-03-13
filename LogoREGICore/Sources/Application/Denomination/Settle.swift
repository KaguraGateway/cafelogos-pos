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
        for var denomination in denominations.denominations {
            // 精算操作として記録
            var updatedDenomination = denomination
            updatedDenomination = Denomination(
                amount: denomination.amount,
                quantity: denomination.quantity,
                createdAt: denomination.createdAt,
                updatedAt: Date(),
                syncAt: denomination.syncAt,
                operationType: .settlement
            )
            await denominationRepo.save(denomination: updatedDenomination)
        }
        paymentRepo.removeAll()
    }
}
