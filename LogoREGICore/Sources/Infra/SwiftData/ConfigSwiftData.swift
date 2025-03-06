//
//  ConfigSwiftData.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@MainActor
public final class ConfigSwiftData: ConfigRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func load() async -> Config {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<ConfigModel>()
        
        do {
            let models = try context.fetch(descriptor)
            if let model = models.first {
                return model.toDomain()
            } else {
                let defaultConfig = Config()
                await save(config: defaultConfig)
                return defaultConfig
            }
        } catch {
            fatalError("Can't Config load: \(error.localizedDescription)")
        }
    }
    
    public func save(config: Config) async {
        let context = modelContainer.mainContext
        
        do {
            let descriptor = FetchDescriptor<ConfigModel>(
                predicate: #Predicate {
                    $0.clientId == config.clientId
                }
            )
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
                existingModel.clientName = config.clientName
                existingModel.isTrainingMode = config.isTrainingMode
                existingModel.isUsePrinter = config.isUsePrinter
                existingModel.isPrintKitchenReceipt = config.isPrintKitchenReceipt
                existingModel.hostUrl = config.hostUrl
                existingModel.isUseSquareTerminal = config.isUseSquareTerminal
                existingModel.squareAccessToken = config.squareAccessToken
                existingModel.squareTerminalDeviceId = config.squareTerminalDeviceId
                existingModel.isUseProductMock = config.isUseProductMock
            } else {
                let model = ConfigModel.fromDomain(config)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            fatalError("Can't Config save: \(error.localizedDescription)")
        }
    }
}
