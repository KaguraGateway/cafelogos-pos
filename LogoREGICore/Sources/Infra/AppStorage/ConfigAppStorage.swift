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
    @AppStorage("adminUrlKey") var adminUrl = ""
    
    @AppStorage("isUseSquareTerminal") var isUseSquareTerminal = false
    @AppStorage("squareAccessToken") var squareAccessToken = ""
    @AppStorage("squareTerminalDeviceId") var squareTerminalDeviceId = ""
    
    @AppStorage("isUseProductMock") var isUseProductMock = false
    @AppStorage("isUseIndividualBilling") var isUseIndividualBilling = false
    
    func load() -> Config {
        if(self.clientId.isEmpty) {
            save(config: Config())
        }
        
        return Config(clientId: self.clientId, clientName: self.clientName, isTrainingMode: self.isTrainingMode, isUsePrinter: self.isUsePrinter, isPrintKitchenReceipt: self.isPrintKitchenReceipt, isUseSquareTerminal: self.isUseSquareTerminal, squareAccessToken: self.squareAccessToken, squareTerminalDeviceId: self.squareTerminalDeviceId, hostUrl: self.hostUrl, adminUrl: self.adminUrl, isUseProductMock: self.isUseProductMock, isUseIndividualBilling: self.isUseIndividualBilling)
    }
    
    func save(config: Config) {
        self.clientId = config.clientId
        self.clientName = config.clientName
        self.isTrainingMode = config.isTrainingMode
        self.isUsePrinter = config.isUsePrinter
        self.isPrintKitchenReceipt = config.isPrintKitchenReceipt
        self.hostUrl = config.hostUrl
        self.adminUrl = config.adminUrl
        self.isUseSquareTerminal = config.isUseSquareTerminal
        self.squareAccessToken = config.squareAccessToken
        self.squareTerminalDeviceId = config.squareTerminalDeviceId
        self.isUseProductMock = config.isUseProductMock
        self.isUseIndividualBilling = config.isUseIndividualBilling
    }
}
