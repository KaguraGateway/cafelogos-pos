//
//  GetDenominations.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/07.
//

import Foundation
import Dependencies

public struct GetDenominations {
    @Dependency(\.denominationRepository) private var denominationRepo
    
    public init() {}
    
    public func Execute() async -> Denominations {
        return await denominationRepo.findAll()
    }
}
