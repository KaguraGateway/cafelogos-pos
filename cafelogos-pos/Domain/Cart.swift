//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Cart: Codable {
    public let items: Array<CartItem>
    
    public init(items: Array<CartItem>) {
        self.items = items
    }
    
    func getTotalPrice() -> UInt64 {
        var totalPrice: UInt64 = 0
        for item in self.items {
            totalPrice += item.price * UInt64(item.getAmount())
        }
        return totalPrice
    }
    
    // TODO: 時間あれば実装する
    func canBuy() -> Bool {
        return true
    }
}
