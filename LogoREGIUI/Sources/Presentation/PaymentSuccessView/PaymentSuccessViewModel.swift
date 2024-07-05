//
//  PaymentSuccessViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import StarIO10
import LogoREGICore

class PaymentSuccessViewModel: ObservableObject {
    public let printer: StarPrinter?
    public let payment: Payment
    public let orders: [Order]
    public let callNumber: String
    
    public init(printer: StarPrinter?, payment: Payment, orders: [Order], callNumber: String) {
        self.printer = printer
        self.payment = payment
        self.orders = orders
        self.callNumber = callNumber
        
        // プレ営業なので無効化
        //self.execPrinter()
    }
    
    func totalQuantity() -> UInt32 {
        return orders.reduce(0, { p, order in
            return p + order.cart.totalQuantity
        })
    }
    func totalCartAmount() -> UInt64 {
        return orders.reduce(0, { p, order in
            return p + order.cart.getTotalPrice()
        })
    }
    func totalAmount() -> UInt64 {
        return orders.reduce(0, { p, order in
            return p + order.totalAmount
        })
    }
}
