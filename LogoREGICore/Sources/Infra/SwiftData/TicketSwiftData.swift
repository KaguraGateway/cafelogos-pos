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
            predicate: #Predicate<TicketModel> {
                $0.prefix == prefix
            },
            sortBy: [SortDescriptor(\.number, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        
        do {
            let models = try context.fetch(descriptor)
            return models.first?.toDomain()
        } catch {
            print("Error fetching last ticket: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func save(ticket: Ticket) async throws {
        let context = modelContainer.mainContext
        
        let descriptor = FetchDescriptor<TicketModel>(
            predicate: #Predicate<TicketModel> {
                $0.id == ticket.id
            }
        )
        
        do {
            let existingModels = try context.fetch(descriptor)
            
            if let existingModel = existingModels.first {
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
