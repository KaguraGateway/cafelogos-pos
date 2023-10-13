//
//  GetConfig.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

public struct GetConfig {
    @Dependency(\.configRepository) private var configRepo
    
    func Execute() -> Config {
        return configRepo.load()
    }
}
