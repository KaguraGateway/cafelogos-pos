//
//  OrderPaymentDao.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

public enum PaymentTypeEnumDao: Int, PersistableEnum, CaseIterable {
    case CASH = 0
}

class PaymentDao: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var orders: List<OrderDao>
    @Persisted var paymentType: PaymentTypeEnumDao
    @Persisted var receiveAmount: Decimal128
    @Persisted var paymentAmount: Decimal128
    @Persisted var changeAmount: Decimal128
    @Persisted var paymentAt: Date
    @Persisted var updatedAt: Date
    @Persisted var syncAt: Date?
}
