//
//  HostUrlUpdater.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import Dependencies

public struct HostUrlUpdater {
    // グローバルなhostUrl値を保持する
    private static var currentHostUrl: String = "http://localhost:8080"
    
    public static func updateHostUrl(_ hostUrl: String) {
        // グローバルなhostUrl値を更新する
        currentHostUrl = hostUrl
    }
    
    public static func getHostUrl() -> String {
        // 現在のhostUrl値を取得する
        return currentHostUrl
    }
}
