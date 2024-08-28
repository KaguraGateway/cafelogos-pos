//
//  Config.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import ULID


public struct Config: Equatable {
    public let clientId: String
    public var clientName: String
    public var isTrainingMode: Bool
    public var isUsePrinter: Bool
    
    public init() {
        self.clientId = ULID().ulidString
        self.clientName = ""
        self.isTrainingMode = false
        self.isUsePrinter = false
    }
    
    public init(clientId: String, clientName: String, isTrainingMode: Bool, isUsePrinter: Bool) {
        self.clientId = clientId
        self.clientName = clientName
        self.isTrainingMode = isTrainingMode
        self.isUsePrinter = isUsePrinter
    }
}

protocol ConfigRepository {
    func load() -> Config
    func save(config: Config)
}
