//
//  Cart.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

public struct Cart {
    private (set) public var items: Array<CartItem>
    public var totalQuantity: UInt32 { get { self.items.reduce(0, { x, y in x + y.getQuantity() }) } }
    
    public init() {
        self.init(items: [])
    }
    
    public init(items: Array<CartItem>) {
        self.items = items
    }
    
    public func getTotalPrice() -> UInt64 {
        var totalPrice: UInt64 = 0
        for item in self.items {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }
    
    // TODO: 時間あれば実装する
    public func canBuy() -> Bool {
        return true
    }
    
    public mutating func addItem(newItem: CartItem) {
        if let i = self.items.firstIndex(where: { $0.productId == newItem.productId && $0.coffeeHowToBrew?.id == newItem.coffeeHowToBrew?.id }) {
            self.items[i].setQuantity(newQuantity: self.items[i].getQuantity() + newItem.getQuantity())
            return
        }
        self.items.append(newItem)
    }
    
    public mutating func setItemQuantity(itemIndex: Int, newQuantity: UInt32) {
        self.items[itemIndex].setQuantity(newQuantity: newQuantity)
    }
    
    public mutating func removeItem(removeItem: CartItem) {
        self.removeItem(removeItemProductId: removeItem.productId, removeItemBrewId: removeItem.coffeeHowToBrew?.id)
    }
    
    public mutating func removeItem(removeItemProductId: String, removeItemBrewId: String?) {
        self.items.removeAll(where: { $0.productId == removeItemProductId && $0.coffeeHowToBrew?.id == removeItemBrewId })
    }
    
    public mutating func removeAllItem() {
        self.items.removeAll()
    }
}
