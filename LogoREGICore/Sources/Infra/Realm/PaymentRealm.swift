//
//  PaymentRealm.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import RealmSwift

func toPayment(dao: PaymentDao) -> Payment {
    return Payment(id: dao.id, type: PaymentType.cash, orderIds: [], paymentAmount: UInt64(dao.paymentAmount.doubleValue), receiveAmount: UInt64(dao.receiveAmount.doubleValue), paymentAt: dao.paymentAt, updatedAt: dao.updatedAt, syncAt: dao.syncAt)
}

public struct PaymentRealm: PaymentRepository {
    public func findAllByUnSettled() async -> [Payment] {
        do {
            let realm = try Realm()
            let daoPayments = realm.objects(PaymentDao.self)
            
            let specificPayments = daoPayments.where {
                $0.settleAt == nil
            }
            
            return specificPayments.map({ toPayment(dao: $0) })
        } catch let err {
            fatalError("Can't Payment findAllByUnSettled: \(err.localizedDescription)")
        }
    }
    
    public func removeAll() async {
        do {
            let realm = try Realm()
            let payments = realm.objects(PaymentDao.self)
            
            try realm.write {
                realm.delete(payments)
            }
        } catch let err {
                fatalError("Can't Payment delete: \(err.localizedDescription)")
        }
    }
    
    public func save(payment: Payment) async {
        let dao = PaymentDao(value: ["id": payment.id, "paymentType": PaymentTypeEnumDao.CASH, "receiveAmount": payment.receiveAmount, "paymentAmount": payment.paymentAmount, "changeAmount": payment.changeAmount, "paymentAt": payment.paymentAt, "updatedAt": Date(), "syncAt": payment.syncAt as Any])
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            print("Can't Payment save: \(err.localizedDescription)")
        }
    }
}
