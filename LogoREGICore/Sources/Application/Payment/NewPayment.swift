//
//  NewPayment.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import Dependencies

public struct NewPayment {
    @Dependency(\.serverPaymentService) var paymentService
    @Dependency(\.paymentRepository) var paymentRepo
    
    @Dependency(\.cashierAdapter) var cashierAdapter
    @Dependency(\.configRepository) var configRepo
    
    @Dependency(\.externalPaymentService) var externalPaymentService
    
    public init() {}
    
    public func Execute(payment: Payment, postOrder: Order?) async -> NewPaymentOutput {
        let config = configRepo.load()

        var receiptItems: [ReceiptItem] = []
        if let order = postOrder {
            receiptItems = generateReceiptItems(order: order)
        }
        print(receiptItems)
        
        let res = await paymentService.postPayment(payment: payment, postOrder: postOrder)
        if res.error == nil {
            paymentRepo.save(payment: payment)
            
            if(config.isUsePrinter) {
                await cashierAdapter.openCacher()
                await cashierAdapter.printReceipt(receipt: OrderReceipt(callNumber: res.callNumber ?? ""))
            }
            if(config.isPrintKitchenReceipt) {
                await cashierAdapter.printKitchenReceipt(orderReceipt: OrderReceipt(callNumber: res.callNumber ?? ""), items: receiptItems)
            }
            
            // 外部決済は在庫確保後に行う
            // NOTE: 決済完了後に在庫がないとやばいからこうしているが、Square画面で✖︎ボタンを押すと決済完了扱いになってしまうので修正するべき
            // FIXME: 決済と在庫確保を分離したい
            if(payment.type == .external) {
                let externalOutput = externalPaymentService.paymentRequest(payment: payment)
                if externalOutput.error != nil {
                    print(externalOutput.error!)
                    return NewPaymentOutput(callNumber: res.callNumber ?? "", error: externalOutput.error)
                }
            }
        }
        
        return NewPaymentOutput(callNumber: res.callNumber ?? "", error: res.error)
    }
    
    private func generateReceiptItems(order: Order) -> [ReceiptItem] {
        var items: [ReceiptItem] = []
        
        for cartItem in order.cart.items {
            let productName = cartItem.productName // 商品名
            let quantity = cartItem.quantity // 個数
            var brewMethod: String? = nil
            let price: Int = Int(cartItem.productPrice)
            
            if let coffeeHowToBrew = cartItem.coffeeHowToBrew {
                // 淹れ方がある場合
                brewMethod = coffeeHowToBrew.name
            }
            // TODO: OtherProductまわりの処理が必要だったら追加する
            
            let receiptItem = ReceiptItem(
                name: productName,
                brewMethod: brewMethod,
                quantity: Int(quantity),
                price: price
            )
            items.append(receiptItem)
        }
        
        return items
    }

}

public struct NewPaymentOutput {
    public let callNumber: String
    public let error: Error?
}
