//
//  DenominationSwiftData.swift
//  cafelogos-pos
//
//  Created by Cline on 2025/02/27.
//

import Foundation
import SwiftData

@MainActor
public final class DenominationSwiftData: DenominationRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func findAll() async -> Denominations {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<DenominationModel>()
        
        do {
            let models = try context.fetch(descriptor)
            return Denominations(denominations: models.map { $0.toDomain() })
        } catch {
            fatalError("Can't Denomination findAll: \(error.localizedDescription)")
        }
    }
    
    public func findById(id: String) async -> Denomination? {
        let context = modelContainer.mainContext
        guard let idInt = Int16(id) else {
            return nil
        }
        
        let descriptor = FetchDescriptor<DenominationModel>(
            predicate: #Predicate<DenominationModel> {
                $0.amount == idInt
            }
        )
        
        do {
            let models = try context.fetch(descriptor)
            return models.first?.toDomain()
        } catch {
            fatalError("Can't Denomination findById: \(error.localizedDescription)")
        }
    }
    
    public func save(denomination: Denomination) async {
        let context = modelContainer.mainContext
        let amountInt16 = Int16(denomination.amount)
        
        do {
            let descriptor = FetchDescriptor<DenominationModel>(
                predicate: #Predicate<DenominationModel> {
                    $0.amount == amountInt16
                }
            )
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
                existingModel.quantity = Int64(denomination.quantity)
                existingModel.updatedAt = denomination.updatedAt
                existingModel.syncAt = denomination.syncAt
            } else {
                let model = DenominationModel.fromDomain(denomination)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            fatalError("Can't Denomination save: \(error.localizedDescription)")
        }
    }
}
