//
//  Config.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import ULID


public struct Config {
    public let clientId: String
    public var clientName: String
    public var isTrainingMode: Bool
    
    public init() {
        self.clientId = ULID().ulidString
        self.clientName = ""
        self.isTrainingMode = false
    }
    
    public init(clientId: String, clientName: String, isTrainingMode: Bool) {
        self.clientId = clientId
        self.clientName = clientName
        self.isTrainingMode = isTrainingMode
    }
    
}

protocol ConfigRepository {
    func load() -> Config
    func save(config: Config)
}
