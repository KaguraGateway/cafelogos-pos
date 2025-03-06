//
//  OrderRealmRepository.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import RealmSwift

public struct OrderRealm: OrderRepository {
    public func save(order: Order) async {
        let dao = OrderDao(
            value: ["id": order.id,  "orderAt": order.orderAt, "syncAt": order.syncAt as Any]
        )
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dao, update: .modified)
            }
        } catch let err {
            fatalError("Can't Order save: \(err.localizedDescription)")
        }
    }
}
