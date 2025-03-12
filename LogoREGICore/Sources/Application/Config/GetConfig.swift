//
//  GetConfig.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

@MainActor
public struct GetConfig {
    @Dependency(\.configRepository) private var configRepo
    
    public init() {}
    
    public func Execute() async -> Config {
        return configRepo.load()
    }
}
