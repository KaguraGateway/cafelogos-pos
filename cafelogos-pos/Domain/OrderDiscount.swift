//
//  OrderDiscount.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import ULID

public struct OrderDiscount {
    public let id: String
    public let orderId: String
    public let discountId: String
    public var syncAt: Date?
    
    init(orderId: String, discountId: String) {
        self.init(id: ULID().ulidString, orderId: orderId, discountId: discountId, syncAt: nil)
    }
    
    init(id: String, orderId: String, discountId: String, syncAt: Date?) {
        self.id = id
        self.orderId = orderId
        self.discountId = discountId
        self.syncAt = syncAt
    }
}
