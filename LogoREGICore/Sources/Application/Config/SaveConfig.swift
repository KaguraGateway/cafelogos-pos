//
//  SaveConfig.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import Dependencies

public struct SaveConfig {
    @Dependency(\.configRepository) private var configRepo
    
    public init() {}
    
   public func Execute(config: Config) {
        let oldConfig = configRepo.load()
        configRepo.save(config: config)
        
        // hostUrlが変更された場合に通知を送信
        if oldConfig.hostUrl != config.hostUrl {
            NotificationCenter.default.post(
                name: .configChanged,
                object: nil,
                userInfo: ["hostUrl": config.hostUrl]
            )
        }
    }
}
