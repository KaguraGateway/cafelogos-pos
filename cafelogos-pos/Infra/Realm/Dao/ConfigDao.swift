//
//  ConfigDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class ConfigDao: Object {
    @Persisted var cfgKey: String
    @Persisted var cfgValue: String
}
