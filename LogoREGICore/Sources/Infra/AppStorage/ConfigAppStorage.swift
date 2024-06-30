//
//  ConfigAppStorage.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import SwiftUI

public struct ConfigAppStorage: ConfigRepository {
    @AppStorage("clientIdKey") var clientId = ""
    @AppStorage("clientNameKey") var clientName = ""
    @AppStorage("isTrainingModeKey") var isTrainingMode = false
    
    func load() -> Config {
        if(self.clientId.isEmpty) {
            save(config: Config())
        }
        
        return Config(clientId: self.clientId, clientName: self.clientName, isTrainingMode: self.isTrainingMode)
    }
    
    func save(config: Config) {
        self.clientId = config.clientId
        self.clientName = config.clientName
        self.isTrainingMode = config.isTrainingMode
    }
}
