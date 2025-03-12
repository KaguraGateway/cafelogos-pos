//
//  ConfigSwiftData.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/12.
//

import Foundation
import SwiftData

@MainActor
public final class ConfigSwiftData: ConfigRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func load() -> Config {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<ConfigModel>()
        
        do {
            let models = try context.fetch(descriptor)
            if let model = models.first {
                return model.toDomain()
            } else {
                // 設定が存在しない場合は新しい設定を作成して保存
                let newConfig = Config()
                save(config: newConfig)
                return newConfig
            }
        } catch {
            fatalError("Can't Config load: \(error.localizedDescription)")
        }
    }
    
    public func save(config: Config) {
        let context = modelContainer.mainContext
        
        do {
            let descriptor = FetchDescriptor<ConfigModel>(
                predicate: #Predicate<ConfigModel> {
                    $0.clientId == config.clientId
                }
            )
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
                // 既存の設定を更新
                existingModel.clientName = config.clientName
                existingModel.isTrainingMode = config.isTrainingMode
                existingModel.isUsePrinter = config.isUsePrinter
                existingModel.isPrintKitchenReceipt = config.isPrintKitchenReceipt
                existingModel.hostUrl = config.hostUrl
                existingModel.isUseSquareTerminal = config.isUseSquareTerminal
                existingModel.squareAccessToken = config.squareAccessToken
                existingModel.squareTerminalDeviceId = config.squareTerminalDeviceId
                existingModel.isUseProductMock = config.isUseProductMock
                existingModel.isUseIndividualBilling = config.isUseIndividualBilling
            } else {
                // 新しい設定を作成
                let model = ConfigModel.fromDomain(config)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            fatalError("Can't Config save: \(error.localizedDescription)")
        }
    }
}
