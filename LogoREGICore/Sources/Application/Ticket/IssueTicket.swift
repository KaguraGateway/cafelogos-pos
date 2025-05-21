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
        print("IssueTicket.Execute(): prefix=\(prefix), startNumber=\(config.ticketNumberStart), isUseTicketNumber=\(config.isUseTicketNumber)")
        let lastTicket = await ticketRepository.findLastTicketByPrefix(prefix: prefix)
        
        let nextNumber: Int
        if let lastTicket = lastTicket {
            let incrementedNumber = lastTicket.number + 1
            nextNumber = max(incrementedNumber, config.ticketNumberStart)
            print("IssueTicket: 最後のチケット番号+1=\(incrementedNumber), 設定開始番号=\(config.ticketNumberStart), 選択された番号=\(nextNumber)")
        } else {
            nextNumber = config.ticketNumberStart
        }
        
        let ticket = Ticket(
            id: ULID().ulidString,
            number: nextNumber,
            prefix: prefix,
            createdAt: Date()
        )
        print("IssueTicket: 生成されたチケット番号: \(ticket.displayNumber)")
        
        do {
            try await ticketRepository.save(ticket: ticket)
        } catch {
            print("Error saving ticket: \(error.localizedDescription)")
        }
        
        return ticket
    }
}
