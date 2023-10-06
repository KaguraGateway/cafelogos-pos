//
//  OrderTicketDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

class OrderTicketDao: Object {
    @Persisted var order: OrderDao
    @Persisted var ticketId: String
    @Persisted var ticketAddr: String
}
