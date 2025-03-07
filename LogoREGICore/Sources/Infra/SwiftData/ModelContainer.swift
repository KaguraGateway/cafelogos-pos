//
//  ModelContainer.swift
//  cafelogos-pos
//
//  Created by Cline on 2025/02/27.
//

import Foundation
import SwiftData

public enum ModelContainerFactory {
    public static let shared: ModelContainer = {
        let schema = Schema([
            DenominationModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
