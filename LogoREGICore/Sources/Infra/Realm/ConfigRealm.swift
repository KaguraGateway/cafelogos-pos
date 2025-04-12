//
//  ConfigRealm.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import RealmSwift

public struct ConfigRealm: ConfigRepository {
    public func load() -> Config {
        do {
            let realm = try Realm()
            // クライアントIDで検索
            if let dao = realm.objects(ConfigDao.self).first {
                return Config(
                    clientId: dao.clientId,
                    clientName: dao.clientName,
                    isTrainingMode: dao.isTrainingMode,
                    isUsePrinter: dao.isUsePrinter,
                    isPrintKitchenReceipt: dao.isPrintKitchenReceipt,
                    isUseSquareTerminal: dao.isUseSquareTerminal,
                    squareAccessToken: dao.squareAccessToken,
                    squareTerminalDeviceId: dao.squareTerminalDeviceId,
                    hostUrl: dao.hostUrl,
                    adminUrl: dao.adminUrl,
                    isUseProductMock: dao.isUseProductMock,
                    isUseIndividualBilling: dao.isUseIndividualBilling,
                    ticketNumberPrefix: dao.ticketNumberPrefix,
                    ticketNumberStart: dao.ticketNumberStart,
                    isUseTicketNumber: dao.isUseTicketNumber
                )
            }
            
            // 設定が存在しない場合は新しい設定を作成して保存
            let newConfig = Config()
            save(config: newConfig)
            return newConfig
        } catch let err {
            print("Config load error: \(err.localizedDescription)")
            // エラーが発生した場合はデフォルト設定を返す
            return Config()
        }
    }
    
    public func save(config: Config) {
        do {
            let realm = try Realm()
            
            // Check if config exists and if values have changed
            if let existingDao = realm.objects(ConfigDao.self).first {
                var needsUpdate = false
                
                try realm.write {
                    // Only update properties that have changed
                    if existingDao.clientName != config.clientName {
                        existingDao.clientName = config.clientName
                        needsUpdate = true
                    }
                    if existingDao.isTrainingMode != config.isTrainingMode {
                        existingDao.isTrainingMode = config.isTrainingMode
                        needsUpdate = true
                    }
                    if existingDao.isUsePrinter != config.isUsePrinter {
                        existingDao.isUsePrinter = config.isUsePrinter
                        needsUpdate = true
                    }
                    if existingDao.isPrintKitchenReceipt != config.isPrintKitchenReceipt {
                        existingDao.isPrintKitchenReceipt = config.isPrintKitchenReceipt
                        needsUpdate = true
                    }
                    if existingDao.hostUrl != config.hostUrl {
                        existingDao.hostUrl = config.hostUrl
                        needsUpdate = true
                    }
                    if existingDao.adminUrl != config.adminUrl {
                        existingDao.adminUrl = config.adminUrl
                        needsUpdate = true
                    }
                    if existingDao.isUseSquareTerminal != config.isUseSquareTerminal {
                        existingDao.isUseSquareTerminal = config.isUseSquareTerminal
                        needsUpdate = true
                    }
                    if existingDao.squareAccessToken != config.squareAccessToken {
                        existingDao.squareAccessToken = config.squareAccessToken
                        needsUpdate = true
                    }
                    if existingDao.squareTerminalDeviceId != config.squareTerminalDeviceId {
                        existingDao.squareTerminalDeviceId = config.squareTerminalDeviceId
                        needsUpdate = true
                    }
                    if existingDao.isUseProductMock != config.isUseProductMock {
                        existingDao.isUseProductMock = config.isUseProductMock
                        needsUpdate = true
                    }
                    if existingDao.isUseIndividualBilling != config.isUseIndividualBilling {
                        existingDao.isUseIndividualBilling = config.isUseIndividualBilling
                        needsUpdate = true
                    }
                    if existingDao.ticketNumberPrefix != config.ticketNumberPrefix {
                        existingDao.ticketNumberPrefix = config.ticketNumberPrefix
                        needsUpdate = true
                    }
                    if existingDao.ticketNumberStart != config.ticketNumberStart {
                        existingDao.ticketNumberStart = config.ticketNumberStart
                        needsUpdate = true
                    }
                    if existingDao.isUseTicketNumber != config.isUseTicketNumber {
                        existingDao.isUseTicketNumber = config.isUseTicketNumber
                        needsUpdate = true
                    }
                    
                    if !needsUpdate {
                        // No changes, cancel the transaction
                        realm.cancelWrite()
                    }
                }
            } else {
                // Config doesn't exist, create a new one
                let dao = ConfigDao()
                dao.clientId = config.clientId
                dao.clientName = config.clientName
                dao.isTrainingMode = config.isTrainingMode
                dao.isUsePrinter = config.isUsePrinter
                dao.isPrintKitchenReceipt = config.isPrintKitchenReceipt
                dao.hostUrl = config.hostUrl
                dao.adminUrl = config.adminUrl
                dao.isUseSquareTerminal = config.isUseSquareTerminal
                dao.squareAccessToken = config.squareAccessToken
                dao.squareTerminalDeviceId = config.squareTerminalDeviceId
                dao.isUseProductMock = config.isUseProductMock
                dao.isUseIndividualBilling = config.isUseIndividualBilling
                dao.ticketNumberPrefix = config.ticketNumberPrefix
                dao.ticketNumberStart = config.ticketNumberStart
                dao.isUseTicketNumber = config.isUseTicketNumber
                
                try realm.write {
                    realm.add(dao)
                }
            }
        } catch let err {
            print("Config save error: \(err.localizedDescription)")
        }
    }
}
