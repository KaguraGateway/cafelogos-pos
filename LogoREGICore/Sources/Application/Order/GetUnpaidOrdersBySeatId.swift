//
//  GetOrdersBySeatName.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import Dependencies

public struct GetUnpaidOrdersById {
    @Dependency(\.serverOrderService) var orderService
    
    public init() {}
    
    public func Execute(seatId: String) async -> [Order] {
        return await orderService.getUnpaidOrdersBySeatId(seatId: seatId)
    }
}
