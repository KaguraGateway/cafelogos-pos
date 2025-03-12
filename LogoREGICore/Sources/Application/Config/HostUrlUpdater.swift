//
//  HostUrlUpdater.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import Dependencies

public struct HostUrlUpdater {
    public static func updateHostUrl(_ hostUrl: String) {
        // グローバルなDependencyValuesを更新するためのメソッド
        // DependencyValues._currentを使用して、グローバルなDependencyValuesインスタンスにアクセスする
        DependencyValues._current.hostUrl = hostUrl
    }
}
