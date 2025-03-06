//
//  OrderSwiftData.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/06.
//

import Foundation
import SwiftData

@MainActor
public final class OrderSwiftData: OrderRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func save(order: Order) async {
        let context = modelContainer.mainContext
        
        do {
            let descriptor = FetchDescriptor<OrderModel>(
                predicate: #Predicate<OrderModel> {
                    $0.id == order.id
                }
            )
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
                existingModel.syncAt = order.syncAt
            } else {
                let model = OrderModel.fromDomain(order)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            fatalError("Can't Order save: \(error.localizedDescription)")
        }
    }
}
