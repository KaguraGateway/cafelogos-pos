import Foundation
import Dependencies
import ULID

public struct IssueTicket {
    @Dependency(\.ticketRepository) var ticketRepository
    @Dependency(\.configRepository) var configRepository
    
    public init() {}
    
    public func Execute() async -> Ticket {
        let config = configRepository.load()
        let prefix = config.ticketNumberPrefix
        let lastTicket = await ticketRepository.findLastTicketByPrefix(prefix: prefix)
        
        let nextNumber: Int
        if let lastTicket = lastTicket {
            nextNumber = lastTicket.number + 1
        } else {
            nextNumber = config.ticketNumberStart
        }
        
        let ticket = Ticket(
            id: ULID().ulidString,
            number: nextNumber,
            prefix: prefix,
            createdAt: Date()
        )
        
        do {
            try await ticketRepository.save(ticket: ticket)
        } catch {
            print("Error saving ticket: \(error.localizedDescription)")
        }
        
        return ticket
    }
}
