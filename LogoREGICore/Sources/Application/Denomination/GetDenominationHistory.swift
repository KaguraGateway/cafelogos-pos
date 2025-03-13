//
//  GetDenominationHistory.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/13.
//

import Foundation
import Dependencies

public struct GetDenominationHistory {
    @Dependency(\.denominationRepository) private var denominationRepo
    
    public init() {}
    
    public func Execute() async -> [Denomination] {
        let denominations = await denominationRepo.findAll()
        return denominations.denominations
    }
}
