//
//  ConfigDao.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import RealmSwift

class ConfigDao: Object {
    @Persisted(primaryKey: true) var clientId: String
    @Persisted var clientName: String
    @Persisted var isTrainingMode: Bool
    @Persisted var isUsePrinter: Bool
    @Persisted var isPrintKitchenReceipt: Bool
    @Persisted var hostUrl: String
    @Persisted var adminUrl: String
    @Persisted var isUseSquareTerminal: Bool
    @Persisted var squareAccessToken: String
    @Persisted var squareTerminalDeviceId: String
    @Persisted var isUseProductMock: Bool
    @Persisted var isUseIndividualBilling: Bool
    
    @Persisted var ticketNumberPrefix: String = "L"
    @Persisted var ticketNumberStart: Int = 1
    @Persisted var isUseTicketNumber: Bool = false
}
