//
//  DenominationModel.swift
//  cafelogos-pos
//
//  Created by Cline on 2025/02/27.
//

import Foundation
import SwiftData

@Model
final class DenominationModel {
    @Attribute(.unique) let amount: Int16
    var quantity: Int64
    private(set) var createdAt: Date
    var updatedAt: Date
    var syncAt: Date?
    var operationType: String
    
    init(amount: Int16, quantity: Int64, createdAt: Date, updatedAt: Date, syncAt: Date? = nil, operationType: String = DenominationOperationType.unknown.rawValue) {
        self.amount = amount
        self.quantity = quantity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncAt = syncAt
        self.operationType = operationType
    }
}

extension DenominationModel {
    func toDomain() -> Denomination {
        Denomination(
            amount: UInt16(amount),
            quantity: UInt64(quantity),
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncAt: syncAt,
            operationType: DenominationOperationType(rawValue: operationType) ?? .unknown
        )
    }
    
    static func fromDomain(_ domain: Denomination) -> DenominationModel {
        DenominationModel(
            amount: Int16(domain.amount),
            quantity: Int64(domain.quantity),
            createdAt: domain.createdAt,
            updatedAt: domain.updatedAt,
            syncAt: domain.syncAt,
            operationType: domain.operationType.rawValue
        )
    }
}
