//
//  GetOrdersBySeatName.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import Dependencies

public struct GetUnpaidOrdersBySeatName {
    @Dependency(\.serverOrderService) var orderService
    func Execute(seatName: String) async -> [Order] {
        return await orderService.getUnpaidOrdersBySeatName(seatName: seatName)
    }
}
