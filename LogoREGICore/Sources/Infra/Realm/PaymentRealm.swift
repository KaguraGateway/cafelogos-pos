//
//  PaymentRealm.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import RealmSwift

func toPayment(dao: PaymentDao) -> Payment {
    return Payment(id: dao.id, type: toPaymentType(dao: dao.paymentType), orderIds: [], paymentAmount: UInt64(dao.paymentAmount.doubleValue), receiveAmount: UInt64(dao.receiveAmount.doubleValue), paymentAt: dao.paymentAt, updatedAt: dao.updatedAt, syncAt: dao.syncAt, callNumbers: Array(dao.callNumbers), canceledAt: dao.canceledAt)
}

func toPaymentType(dao: PaymentTypeEnumDao) -> PaymentType {
    switch dao {
    case .CASH:
        return PaymentType.cash
    case .EXTERNAL:
        return PaymentType.external
    }
}

func toPaymentTypeDao(type: PaymentType) -> PaymentTypeEnumDao {
    switch type {
    case .cash:
        return PaymentTypeEnumDao.CASH
    case .external:
        return PaymentTypeEnumDao.EXTERNAL
    }
}

public struct PaymentRealm: PaymentRepository {
    func findAllByUnSettled() -> [Payment] {
        do {
            let realm = try Realm()
            let daoPayments = realm.objects(PaymentDao.self)
            
            // 取消済みはレジ内の現金に影響しないため、未精算の集計対象から除外する
            let specificPayments = daoPayments.where {
                $0.settleAt == nil && $0.canceledAt == nil
            }
            
            return specificPayments.map({ toPayment(dao: $0) })
        } catch let err {
            print("Error in Payment findAllByUnSettled: \(err.localizedDescription)")
            return []
        }
    }
    
    func removeAll() {
        do {
            let realm = try Realm()
            let payments = realm.objects(PaymentDao.self)
            
            try realm.write {
                realm.delete(payments)
            }
        } catch let err {
                print("Error in Payment delete: \(err.localizedDescription)")
        }
    }
    
    func save(payment: Payment) {
        let dao = PaymentDao(value: ["id": payment.id, "paymentType": toPaymentTypeDao(type: payment.type), "receiveAmount": payment.receiveAmount, "paymentAmount": payment.paymentAmount, "changeAmount": payment.changeAmount, "paymentAt": payment.paymentAt, "updatedAt": Date(), "syncAt": payment.syncAt as Any, "callNumbers": payment.callNumbers, "canceledAt": payment.canceledAt as Any])
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            print("Can't Payment save: \(err.localizedDescription)")
        }
    }
    
    func findAll() -> [Payment] {
        do {
            let realm = try Realm()
            let daoPayments = realm.objects(PaymentDao.self)
            
            return daoPayments.map({ toPayment(dao: $0) })
        } catch let err {
            print("Error in Payment findAll: \(err.localizedDescription)")
            return []
        }
    }

    func findById(paymentId: String) -> Payment? {
        do {
            let realm = try Realm()
            guard let dao = realm.object(ofType: PaymentDao.self, forPrimaryKey: paymentId) else {
                return nil
            }
            return toPayment(dao: dao)
        } catch let err {
            print("Error in Payment findById: \(err.localizedDescription)")
            return nil
        }
    }

    /// 決済を取消済みとして記録する（レコードは削除せず履歴として残す）
    func cancel(paymentId: String, canceledAt: Date) {
        do {
            let realm = try Realm()
            guard let dao = realm.object(ofType: PaymentDao.self, forPrimaryKey: paymentId) else {
                print("Error in Payment cancel: payment not found: \(paymentId)")
                return
            }
            try realm.write {
                dao.canceledAt = canceledAt
                dao.updatedAt = Date()
            }
        } catch let err {
            print("Can't Payment cancel: \(err.localizedDescription)")
        }
    }
}
