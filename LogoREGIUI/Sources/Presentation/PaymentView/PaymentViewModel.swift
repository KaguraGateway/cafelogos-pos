//
//  PaymentViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import StarIO10
import LogoREGICore

class PaymentViewModel: ObservableObject {
    @Published var payment: Payment
    @Published var orders: [Order]
    @Published var newOrder: Order?
    @Published var callNumber: String = ""
    @Published var showingSuccessSheet = false
    @Published var errorMessage: String? = nil
    @Published var showingError = false
    
    public init(orders: [Order], newOrder: Order?) {
        self.orders = orders
        self.newOrder = newOrder
        self.payment = Payment(type: PaymentType.cash, orderIds: orders.map { $0.id }, paymentAmount: PaymentDomainService().getTotalAmount(orders: orders), receiveAmount: 0)
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
    
    func isEnoughAmount() -> Bool {
        return PaymentDomainService().isEnoughAmount(payment: self.payment, orders: self.orders)
    }
    
    func onTapPay() async {
        if !isEnoughAmount() {
            print("不足")
        }
        let result = await NewPayment().Execute(payment: payment, postOrder: newOrder)
        if result.error != nil {
            errorMessage = "お支払いは完了していません。\nやり直してください。\n\(String(describing: result.error?.localizedDescription))"
            showingError = true
        } else {
            callNumber = result.callNumber
            self.showingSuccessSheet.toggle()
        }
    }
    
    func onTapKeyboard(str: String) {
        let prev = payment.receiveAmount == 0 ? "" : String(payment.receiveAmount)
        
        switch(str) {
        case "¥1,000":
            payment.receiveAmount += 1000
            break
        case "¥500":
            payment.receiveAmount += 500
            break
        case "⌫":
            payment.receiveAmount = 0
        case "0","00","000":
            payment.receiveAmount = UInt64("\(prev)\(str)")!
            break
        default:
            payment.receiveAmount = UInt64("\(prev)\(str)")!
        }
    }
}
