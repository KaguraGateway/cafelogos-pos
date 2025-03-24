//
//  ConfigRealm.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/24.
//

import Foundation
import RealmSwift

public struct ConfigRealm: ConfigRepository {
    func load() -> Config {
        do {
            let realm = try Realm()
            let configs = realm.objects(ConfigDao.self)
            
            // Return default config if no configs exist
            if configs.isEmpty {
                let config = Config()
                save(config: config)
                return config
            }
            
            let dao = configs.first!
            
            return Config(
                clientId: dao.clientId,
                clientName: dao.clientName,
                isTrainingMode: dao.isTrainingMode,
                isUsePrinter: dao.isUsePrinter,
                isPrintKitchenReceipt: dao.isPrintKitchenReceipt,
                isUseClientTicketNumbering: dao.isUseClientTicketNumbering,
                isUseSquareTerminal: dao.isUseSquareTerminal,
                squareAccessToken: dao.squareAccessToken,
                squareTerminalDeviceId: dao.squareTerminalDeviceId,
                hostUrl: dao.hostUrl,
                adminUrl: dao.adminUrl,
                isUseProductMock: dao.isUseProductMock,
                isUseIndividualBilling: dao.isUseIndividualBilling
            )
        } catch let err {
            print("Error loading config: \(err.localizedDescription)")
            // Return default config on error
            let config = Config()
            save(config: config)
            return config
        }
    }
    
    func save(config: Config) {
        let dao = ConfigDao()
        dao.clientId = config.clientId
        dao.clientName = config.clientName
        dao.isTrainingMode = config.isTrainingMode
        dao.isUsePrinter = config.isUsePrinter
        dao.isPrintKitchenReceipt = config.isPrintKitchenReceipt
        dao.isUseClientTicketNumbering = config.isUseClientTicketNumbering
        dao.hostUrl = config.hostUrl
        dao.adminUrl = config.adminUrl
        dao.isUseSquareTerminal = config.isUseSquareTerminal
        dao.squareAccessToken = config.squareAccessToken
        dao.squareTerminalDeviceId = config.squareTerminalDeviceId
        dao.isUseProductMock = config.isUseProductMock
        dao.isUseIndividualBilling = config.isUseIndividualBilling
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            print("Error saving config: \(err.localizedDescription)")
        }
    }
}
