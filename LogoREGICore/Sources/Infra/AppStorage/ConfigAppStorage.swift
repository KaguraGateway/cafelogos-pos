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
    @AppStorage("isUsePrinter") var isUsePrinter = false
    @AppStorage("isPrintKitchenReceipt") var isPrintKitchenReceipt = false
    @AppStorage("hostKey") var hostUrl = "http://localhost:8080"
    
    @AppStorage("isUseSquareTerminal") var isUseSquareTerminal = false
    @AppStorage("squareAccessToken") var squareAccessToken = ""
    @AppStorage("squareTerminalDeviceId") var squareTerminalDeviceId = ""
    
    @AppStorage("isUseProductMock") var isUseProductMock = false
    
    public func load() async -> Config {
        if(self.clientId.isEmpty) {
            await save(config: Config())
        }
        
        return Config(clientId: self.clientId, clientName: self.clientName, isTrainingMode: self.isTrainingMode, isUsePrinter: self.isUsePrinter, isPrintKitchenReceipt: self.isPrintKitchenReceipt, isUseSquareTerminal: self.isUseSquareTerminal, squareAccessToken: self.squareAccessToken, squareTerminalDeviceId: self.squareTerminalDeviceId, hostUrl: self.hostUrl, isUseProductMock: self.isUseProductMock)
    }
    
    public func save(config: Config) async {
        self.clientId = config.clientId
        self.clientName = config.clientName
        self.isTrainingMode = config.isTrainingMode
        self.isUsePrinter = config.isUsePrinter
        self.isPrintKitchenReceipt = config.isPrintKitchenReceipt
        self.hostUrl = config.hostUrl
        self.isUseSquareTerminal = config.isUseSquareTerminal
        self.squareAccessToken = config.squareAccessToken
        self.squareTerminalDeviceId = config.squareTerminalDeviceId
        self.isUseProductMock = config.isUseProductMock
    }
}
