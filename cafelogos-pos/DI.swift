//
//  DI.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import Dependencies

private enum DenominationRepositoryKey: DependencyKey {
    static let liveValue: any DenominationRepository = DenominationRealm()
}
private enum ConfigRepositoryKey: DependencyKey {
    static let liveValue: any ConfigRepository = ConfigAppStorage()
}

extension DependencyValues {
    var denominationRepository: any DenominationRepository {
        get { self[DenominationRepositoryKey.self] }
        set { self[DenominationRepositoryKey.self] = newValue }
    }
    var configRepository: any ConfigRepository {
        get { self[ConfigRepositoryKey.self] }
        set{ self[ConfigRepositoryKey.self] = newValue }
    }
}
