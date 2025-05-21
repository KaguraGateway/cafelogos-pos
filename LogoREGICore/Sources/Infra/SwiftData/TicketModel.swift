import Foundation
import SwiftData

@Model
public final class TicketModel {
    @Attribute(.unique) public var id: String
    public var number: Int
    public var prefix: String
    public var createdAt: Date
    
    public init(id: String, number: Int, prefix: String, createdAt: Date) {
        self.id = id
        self.number = number
        self.prefix = prefix
        self.createdAt = createdAt
    }
    
    public static func fromDomain(_ domain: Ticket) -> TicketModel {
        return TicketModel(
            id: domain.id,
            number: domain.number,
            prefix: domain.prefix,
            createdAt: domain.createdAt
        )
    }
    
    public func toDomain() -> Ticket {
        return Ticket(
            id: id,
            number: number,
            prefix: prefix,
            createdAt: createdAt
        )
    }
}
