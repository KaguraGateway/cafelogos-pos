//
//  GeneralSettingViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation

class GeneralSettingViewModel: ObservableObject {
    @Published private var config: Config
    
    public init() {
        self.config = GetConfig().Execute()
    }
    
    public var clientId: String {
        get {
            return self.config.clientId
        }
    }
    
    public var clientName: String {
        get {
            return self.config.clientName
        }
        set {
            self.config.clientName = newValue
            SaveConfig().Execute(config: config)
        }
    }}
