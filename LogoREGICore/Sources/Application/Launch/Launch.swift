//
//  Launch.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies
import RealmSwift

public struct Launch {
    @Dependency(\.configRepository) private var configRepo
    @Dependency(\.configObserver) private var configObserver
    @Dependency(\.customerDisplay) private var customerDisplay
    
    public init() {}
    
    public func Execute() {
        // Realm Migrate
        let realmConfig = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { migration, oldSchemaVer in
                if oldSchemaVer < 1 {
                    migration.create(PaymentDao.className(), value: ["settleAt": nil])
                }
                if oldSchemaVer < 3 {
                    // ConfigDaoを作成
                    migration.create(ConfigDao.className())
                }
                // schemaVersion 5: PaymentDaoにcallNumbersを追加（既存データは空Listで自動補完）
                // スキーマ4（開発中に使っていたcallNumber単体）からは、その値を引き継ぐ
                if oldSchemaVer == 4 {
                    migration.enumerateObjects(ofType: PaymentDao.className()) { oldObject, newObject in
                        guard let callNumber = oldObject?["callNumber"] as? String, !callNumber.isEmpty else { return }
                        newObject?["callNumbers"] = [callNumber]
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = realmConfig
        
        let config = configRepo.load()
        print("Launch; ClientId: \(config.clientId)")
        
        // ConfigObserverを初期化して監視を開始
        configObserver.startObserving()
        
        _ = customerDisplay
    }
}
