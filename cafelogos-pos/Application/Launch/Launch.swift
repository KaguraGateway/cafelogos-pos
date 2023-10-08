//
//  Launch.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

public struct Launch {
    @Dependency(\.configRepository) private var configRepo
    
    func Execute() {
        let config = configRepo.load()
        print("Launch; ClientId: \(config.clientId)")
    }
}
