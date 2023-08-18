//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Cart: Codable {
    private var items: Array<CartItem>
    var totalAmount: UInt32 { get { self.items.reduce(0, { x, y in x + y.getAmount() }) } }
    
    public init() {
        self.init(items: [])
    }
    
    public init(items: Array<CartItem>) {
        self.items = items
    }
    
    func getTotalPrice() -> UInt64 {
        var totalPrice: UInt64 = 0
        for item in self.items {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }
    
    // TODO: 時間あれば実装する
    func canBuy() -> Bool {
        return true
    }
    
    mutating func addItem(newItem: CartItem) {
        if let i = self.items.firstIndex(where: { $0.productId == newItem.productId && $0.coffeeHowToBrew?.id == newItem.coffeeHowToBrew?.id }) {
            self.items[i].setAmount(newAmount: self.items[i].getAmount() + newItem.getAmount())
            return
        }
        self.items.append(newItem)
    }
    
    mutating func setItemAmount(itemIndex: Int, newAmount: UInt32) {
        items[itemIndex].setAmount(newAmount: newAmount)
    }
    
    mutating func removeItem(removeItem: CartItem) {
        self.items.removeAll(where: { $0.productId == removeItem.productId && $0.coffeeHowToBrew?.id == removeItem.coffeeHowToBrew?.id })
    }
    
    mutating func removeAllItem() {
        self.items.removeAll()
    }
    
    func getItems() -> Array<CartItem> {
        return self.items
    }
}
