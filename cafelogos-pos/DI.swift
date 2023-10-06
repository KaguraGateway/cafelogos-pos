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

extension DependencyValues {
    var denominationRepository: any DenominationRepository {
        get { self[DenominationRepositoryKey.self] }
        set { self[DenominationRepositoryKey.self] = newValue }
    }
}
