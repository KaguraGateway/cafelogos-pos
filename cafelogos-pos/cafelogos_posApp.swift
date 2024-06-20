//
//  cafelogos_posApp.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/08.
//

import SwiftUI
import RealmSwift

@main
struct cafelogos_posApp: SwiftUI.App {
    public init() {
        // Realm Migrate
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVer in
                if oldSchemaVer < 1 {
                    migration.create(PaymentDao.className(), value: ["settleAt": nil])
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        // Launch
        Launch().Execute()
    }
    
    var body: some Scene {
        WindowGroup {
            StartTransactionView()
        }
    }
}
