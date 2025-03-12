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
    
    public init() {}
    
    public func Execute() {
        // Realm Migrate
        let realmConfig = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVer in
                if oldSchemaVer < 1 {
                    migration.create(PaymentDao.className(), value: ["settleAt": nil])
                }
                if oldSchemaVer < 3 {
                    // ConfigDaoを作成
                    migration.create(ConfigDao.className())
                }
            }
        )
        Realm.Configuration.defaultConfiguration = realmConfig
        
        let config = configRepo.load()
        print("Launch; ClientId: \(config.clientId)")
    }
}
