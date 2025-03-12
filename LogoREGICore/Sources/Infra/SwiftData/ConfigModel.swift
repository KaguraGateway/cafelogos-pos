//
//  ConfigModel.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import SwiftData

@Model
final class ConfigModel {
    @Attribute(.unique) var clientId: String
    var clientName: String
    var isTrainingMode: Bool
    var isUsePrinter: Bool
    var isPrintKitchenReceipt: Bool
    var hostUrl: String
    var isUseSquareTerminal: Bool
    var squareAccessToken: String
    var squareTerminalDeviceId: String
    var isUseProductMock: Bool
    var isUseIndividualBilling: Bool
    
    init(clientId: String, clientName: String, isTrainingMode: Bool, isUsePrinter: Bool, isPrintKitchenReceipt: Bool, hostUrl: String, isUseSquareTerminal: Bool, squareAccessToken: String, squareTerminalDeviceId: String, isUseProductMock: Bool, isUseIndividualBilling: Bool) {
        self.clientId = clientId
        self.clientName = clientName
        self.isTrainingMode = isTrainingMode
        self.isUsePrinter = isUsePrinter
        self.isPrintKitchenReceipt = isPrintKitchenReceipt
        self.hostUrl = hostUrl
        self.isUseSquareTerminal = isUseSquareTerminal
        self.squareAccessToken = squareAccessToken
        self.squareTerminalDeviceId = squareTerminalDeviceId
        self.isUseProductMock = isUseProductMock
        self.isUseIndividualBilling = isUseIndividualBilling
    }
}

extension ConfigModel {
    func toDomain() -> Config {
        Config(
            clientId: clientId,
            clientName: clientName,
            isTrainingMode: isTrainingMode,
            isUsePrinter: isUsePrinter,
            isPrintKitchenReceipt: isPrintKitchenReceipt,
            isUseSquareTerminal: isUseSquareTerminal,
            squareAccessToken: squareAccessToken,
            squareTerminalDeviceId: squareTerminalDeviceId,
            hostUrl: hostUrl,
            isUseProductMock: isUseProductMock,
            isUseIndividualBilling: isUseIndividualBilling
        )
    }
    
    static func fromDomain(_ domain: Config) -> ConfigModel {
        ConfigModel(
            clientId: domain.clientId,
            clientName: domain.clientName,
            isTrainingMode: domain.isTrainingMode,
            isUsePrinter: domain.isUsePrinter,
            isPrintKitchenReceipt: domain.isPrintKitchenReceipt,
            hostUrl: domain.hostUrl,
            isUseSquareTerminal: domain.isUseSquareTerminal,
            squareAccessToken: domain.squareAccessToken,
            squareTerminalDeviceId: domain.squareTerminalDeviceId,
            isUseProductMock: domain.isUseProductMock,
            isUseIndividualBilling: domain.isUseIndividualBilling
        )
    }
}
