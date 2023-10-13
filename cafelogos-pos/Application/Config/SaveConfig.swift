//
//  SaveConfig.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

public struct SaveConfig {
    @Dependency(\.configRepository) private var configRepo
    
    func Execute(config: Config) {
        configRepo.save(config: config)
    }
}
