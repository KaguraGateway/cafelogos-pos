import Foundation
import SwiftData

@MainActor
public final class TicketSwiftData: TicketRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func findLastTicketByPrefix(prefix: String) async -> Ticket? {
        let context = modelContainer.mainContext
        
        let descriptor = FetchDescriptor<TicketModel>(
            sortBy: [SortDescriptor(\.number, order: .reverse)]
        )
        
        do {
            let allModels = try context.fetch(descriptor)
            let filteredModels = allModels.filter { $0.prefix == prefix }
            return filteredModels.first?.toDomain()
        } catch {
            print("Error fetching last ticket: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func save(ticket: Ticket) async throws {
        let context = modelContainer.mainContext
        
        let descriptor = FetchDescriptor<TicketModel>()
        
        do {
            let allModels = try context.fetch(descriptor)
            let existingModel = allModels.first { $0.id == ticket.id }
            
            if let existingModel = existingModel {
                existingModel.number = ticket.number
                existingModel.prefix = ticket.prefix
                existingModel.createdAt = ticket.createdAt
            } else {
                let model = TicketModel.fromDomain(ticket)
                context.insert(model)
            }
            
            try context.save()
        } catch {
            throw error
        }
    }
}
