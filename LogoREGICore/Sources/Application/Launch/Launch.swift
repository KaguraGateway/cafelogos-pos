//
//  Launch.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies
import SwiftData

public struct Launch {
    @Dependency(\.configRepository) private var configRepo
    
    public init() {}
    
    public func Execute() async {
        // SwiftData migration is handled automatically by the ModelContainer
        
        let config = await configRepo.load()
        print("Launch; ClientId: \(config.clientId)")
    }
}
