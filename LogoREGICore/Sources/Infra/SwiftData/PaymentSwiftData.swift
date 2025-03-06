//
//  PaymentSwiftData.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@MainActor
public final class PaymentSwiftData: PaymentRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func findAllByUnSettled() async -> [Payment] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<PaymentModel>(
            predicate: #Predicate {
                $0.settleAt == nil
            }
        )
        
        do {
            let models = try context.fetch(descriptor)
            return models.map { $0.toDomain() }
        } catch {
            fatalError("Can't Payment findAllByUnSettled: \(error.localizedDescription)")
        }
    }
    
    public func removeAll() async {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<PaymentModel>()
        
        do {
            let models = try context.fetch(descriptor)
            for model in models {
                context.delete(model)
            }
            try context.save()
        } catch {
            fatalError("Can't Payment removeAll: \(error.localizedDescription)")
        }
    }
    
    public func save(payment: Payment) async {
        let context = modelContainer.mainContext
        let paymentId = payment.id
        
        do {
            let descriptor = FetchDescriptor<PaymentModel>(
                predicate: #Predicate {
                    $0.id == paymentId
                }
            )
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
                existingModel.receiveAmount = Int64(payment.receiveAmount)
                existingModel.updatedAt = payment.updatedAt
                existingModel.syncAt = payment.syncAt
            } else {
                let model = PaymentModel.fromDomain(payment)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            fatalError("Can't Payment save: \(error.localizedDescription)")
        }
    }
}
