//
//  SaveConfig.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

@MainActor
public struct SaveConfig {
    @Dependency(\.configRepository) private var configRepo
    
    public init() {}
    
    public func Execute(config: Config) async {
        configRepo.save(config: config)
    }
}
