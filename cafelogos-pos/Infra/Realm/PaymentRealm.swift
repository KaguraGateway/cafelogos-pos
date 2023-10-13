//
//  PaymentRealm.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import RealmSwift

func toPayment(dao: PaymentDao) -> Payment {
    return Payment(id: dao.id, type: PaymentType(rawValue: dao.paymentType.rawValue)!, orderIds: dao.orders.map({ $0.id }), paymentAmount: UInt64(dao.paymentAmount.doubleValue), receiveAmount: UInt64(dao.receiveAmount.doubleValue), paymentAt: dao.paymentAt, updatedAt: dao.updatedAt, syncAt: dao.syncAt)
}

public struct PaymentRealm: PaymentRepository {
    func findAll() -> [Payment] {
        do {
            let realm = try Realm()
            let daoPayments = realm.objects(PaymentDao.self)
            
            return daoPayments.map({ toPayment(dao: $0) })
        } catch let err {
            fatalError("Can't Payment findAll: \(err.localizedDescription)")
        }
    }
    
    func findById(id: String) -> Payment? {
        do {
            let realm = try Realm()
            let dao = realm.object(ofType: PaymentDao.self, forPrimaryKey: id)
            
            if dao == nil {
                return nil
            }
            return toPayment(dao: dao!)
        } catch let err {
            fatalError("Can't Payment findById: \(err.localizedDescription)")
        }
    }
    
    func save(payment: Payment) {
        let daoOrders = payment.orderIds.map { OrderDao(value: ["id": $0]) }
        let dao = PaymentDao(value: ["id": payment.id, "orders": daoOrders, "paymentType": PaymentTypeEnumDao.CASH, "receiveAmount": payment.receiveAmount, "paymentAmount": payment.paymentAmount, "changeAmount": payment.changeAmount, "paymentAt": payment.paymentAt, "updatedAt": Date(), "syncAt": payment.syncAt as Any])
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            fatalError("Can't Payment save: \(err.localizedDescription)")
        }
    }
}
