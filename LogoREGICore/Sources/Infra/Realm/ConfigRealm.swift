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
                    isUseIndividualBilling: dao.isUseIndividualBilling
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
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            print("Config save error: \(err.localizedDescription)")
        }
    }
}
