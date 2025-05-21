import Foundation

public struct Ticket: Equatable {
    public let id: String
    public let number: Int
    public let prefix: String
    public let createdAt: Date
    
    public init(id: String, number: Int, prefix: String, createdAt: Date) {
        self.id = id
        self.number = number
        self.prefix = prefix
        self.createdAt = createdAt
    }
    
    public var displayNumber: String {
        return "\(prefix)-\(number)"
    }
}

public protocol TicketRepository {
    func findLastTicketByPrefix(prefix: String) async -> Ticket?
    func save(ticket: Ticket) async throws
    func removeAll() async
}
