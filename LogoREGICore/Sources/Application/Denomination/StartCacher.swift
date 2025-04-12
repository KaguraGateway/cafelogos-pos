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
    @Dependency(\.paymentRepository) private var paymentRepo
    @Dependency(\.ticketRepository) private var ticketRepo
    
    public init() {}
    
    public func Execute(denominations: Denominations) async {
        for var denomination in denominations.denominations {
            // レジ開け操作として記録
            var updatedDenomination = denomination
            updatedDenomination = Denomination(
                amount: denomination.amount,
                quantity: denomination.quantity,
                createdAt: denomination.createdAt,
                updatedAt: Date(),
                syncAt: denomination.syncAt,
                operationType: .cashDrawerOpening
            )
            await denominationRepo.save(denomination: updatedDenomination)
        }
        paymentRepo.removeAll()
        await ticketRepo.removeAll()
        print("StartCacher: チケットDBをクリアしました")
    }
}
