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
    public var adminUrl: String
    
    public var isUseSquareTerminal: Bool
    public var squareAccessToken: String
    public var squareTerminalDeviceId: String
    
    public var isUseProductMock: Bool
    public var isUseIndividualBilling: Bool
    
    public var ticketNumberPrefix: String
    public var ticketNumberStart: Int
    public var isUseTicketNumber: Bool
    
    public init() {
        self.clientId = ULID().ulidString
        self.clientName = ""
        self.isTrainingMode = false
        self.isUsePrinter = false
        self.isPrintKitchenReceipt = false
        self.hostUrl = "http://localhost:8080"
        self.adminUrl = ""
        self.isUseSquareTerminal = false
        self.squareAccessToken = ""
        self.squareTerminalDeviceId = ""
        self.isUseProductMock = false
        self.isUseIndividualBilling = false
        self.ticketNumberPrefix = "L"
        self.ticketNumberStart = 1
        self.isUseTicketNumber = false
    }
    
    public init(clientId: String, clientName: String, isTrainingMode: Bool, isUsePrinter: Bool, isPrintKitchenReceipt: Bool, isUseSquareTerminal: Bool, squareAccessToken: String, squareTerminalDeviceId: String, hostUrl: String, adminUrl: String = "", isUseProductMock: Bool = false, isUseIndividualBilling: Bool = false, ticketNumberPrefix: String = "L", ticketNumberStart: Int = 1, isUseTicketNumber: Bool = false) {
        self.clientId = clientId
        self.clientName = clientName
        self.isTrainingMode = isTrainingMode
        self.isUsePrinter = isUsePrinter
        self.isPrintKitchenReceipt = isPrintKitchenReceipt
        self.hostUrl = hostUrl
        self.adminUrl = adminUrl
        self.isUseSquareTerminal = isUseSquareTerminal
        self.squareAccessToken = squareAccessToken
        self.squareTerminalDeviceId = squareTerminalDeviceId
        self.isUseProductMock = isUseProductMock
        self.isUseIndividualBilling = isUseIndividualBilling
        self.ticketNumberPrefix = ticketNumberPrefix
        self.ticketNumberStart = ticketNumberStart
        self.isUseTicketNumber = isUseTicketNumber
    }
}

protocol ConfigRepository {
    func load() -> Config
    func save(config: Config)
}

// 設定変更通知用の拡張
extension Notification.Name {
    public static let configChanged = Notification.Name("configChanged")
}
