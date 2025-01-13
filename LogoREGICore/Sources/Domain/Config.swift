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
public var isPrintKitchenReceipt: Bool
public var hostUrl: String

public var isUseSquareTerminal: Bool
public var squareAccessToken: String
public var squareTerminalDeviceId: String

public init() {
    self.clientId = ULID().ulidString
    self.clientName = ""
    self.isTrainingMode = false
    self.isUsePrinter = false
    self.isPrintKitchenReceipt = false
    self.hostUrl = "http://localhost:8080"
    self.isUseSquareTerminal = false
    self.squareAccessToken = ""
    self.squareTerminalDeviceId = ""
}

public init(clientId: String, clientName: String, isTrainingMode: Bool, isUsePrinter: Bool, isPrintKitchenReceipt: Bool, isUseSquareTerminal: Bool, squareAccessToken: String, squareTerminalDeviceId: String, hostUrl: String) {
    self.clientId = clientId
    self.clientName = clientName
    self.isTrainingMode = isTrainingMode
    self.isUsePrinter = isUsePrinter
    self.isPrintKitchenReceipt = isPrintKitchenReceipt
    self.hostUrl = hostUrl
    self.isUseSquareTerminal = isUseSquareTerminal
    self.squareAccessToken = squareAccessToken
    self.squareTerminalDeviceId = squareTerminalDeviceId
}
}

protocol ConfigRepository {
func load() -> Config
func save(config: Config)
}
