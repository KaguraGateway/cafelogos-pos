//
//  DenominationRealm.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import RealmSwift

func toDenomination(dao: DenominationDao) -> Denomination {
    return Denomination(amount: UInt16(dao.denomination), quantity: UInt64(dao.amount.doubleValue), createdAt: dao.createdAt, updatedAt: dao.updatedAt, syncAt: dao.syncAt)
}

public struct DenominationRealm: DenominationRepository {
    func findAll() -> Denominations {
        do {
            let realm = try Realm()
            let daoDenominations = realm.objects(DenominationDao.self)
            
            return Denominations(denominations: daoDenominations.map { toDenomination(dao: $0) })
        } catch let err {
            fatalError("Can't Denomination findAll: \(err.localizedDescription)")
        }
    }
    
    func findById(id: String) -> Denomination? {
        do {
            let realm = try Realm()
            let dao = realm.object(ofType: DenominationDao.self, forPrimaryKey: id)
            
            if dao == nil {
                return nil
            }
            return toDenomination(dao: dao!)
        } catch let err {
            fatalError("Can't Denomination findById: \(err.localizedDescription)")
        }
    }
    
    func save(denomination: Denomination) {
        let dao = DenominationDao(value: ["denomination": denomination.amount, "amount": denomination.quantity, "createdAt": denomination.createdAt, "updatedAt": denomination.updatedAt, "syncAt": denomination.syncAt as Any])
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            fatalError("Can't Denomination save: \(err.localizedDescription)")
        }
    }
}
