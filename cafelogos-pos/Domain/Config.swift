//
//  Config.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation

public struct Config {
    public let cfgKey: String
    public let cfgValue: String
    
    public init(cfgKey: String, cfgValue: String) {
        self.cfgKey = cfgKey
        self.cfgValue = cfgValue
    }
}
