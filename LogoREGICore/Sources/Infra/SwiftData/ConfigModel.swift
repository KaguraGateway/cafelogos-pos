//
//  ConfigModel.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@Model
public final class ConfigModel {
    @Attribute(.unique) public let clientId: String
    public var clientName: String
    public var isTrainingMode: Bool
    public var isUsePrinter: Bool
    public var isPrintKitchenReceipt: Bool
    public var hostUrl: String
    public var isUseSquareTerminal: Bool
    public var squareAccessToken: String
    public var squareTerminalDeviceId: String
    public var isUseProductMock: Bool
    
    public init(clientId: String, clientName: String, isTrainingMode: Bool, isUsePrinter: Bool, isPrintKitchenReceipt: Bool, hostUrl: String, isUseSquareTerminal: Bool, squareAccessToken: String, squareTerminalDeviceId: String, isUseProductMock: Bool) {
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
    }
}

extension ConfigModel {
    public func toDomain() -> Config {
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
            isUseProductMock: isUseProductMock
        )
    }
    
    public static func fromDomain(_ domain: Config) -> ConfigModel {
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
            isUseProductMock: domain.isUseProductMock
        )
    }
}
