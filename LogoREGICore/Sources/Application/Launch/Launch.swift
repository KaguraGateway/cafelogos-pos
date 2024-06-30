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
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVer in
                if oldSchemaVer < 1 {
                    migration.create(PaymentDao.className(), value: ["settleAt": nil])
                }
            }
        )
        Realm.Configuration.defaultConfiguration = realmConfig
        
        let config = configRepo.load()
        print("Launch; ClientId: \(config.clientId)")
    }
}
