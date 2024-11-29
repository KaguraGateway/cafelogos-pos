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
    
    public init() {}
    
    public func Execute(payment: Payment, postOrder: Order?) async -> NewPaymentOutput {
        let config = configRepo.load()

        var orderSummary = ""
         商品リストを取得
        if let order = postOrder {
            for cartItem in order.cart.items {
                // 商品名
                let productName = cartItem.productName
                // 個数
                let quantity = cartItem.quantity
                // 淹れ方
                if let coffeeHowToBrew = cartItem.coffeeHowToBrew {
                    let brewMethod = coffeeHowToBrew.name // 淹れ方名
                    let itemSummary = "・\(productName)(\(brewMethod)) x\(quantity) ¥\(cartItem.productPrice)"
                    orderSummary += itemSummary + "\n"
                } else {
                    // coffeeHowToBrewがない場合
                    if let otherProduct = cartItem.otherProduct {
                        let otherProductName = otherProduct.productName
                        let price = otherProduct.price
                        let itemSummary = "・\(otherProductName) x\(quantity) ¥\(price)"
                        orderSummary += itemSummary + "\n"  // 商品情報を追加
                    } else {
                        // otherProductもない場合
                        let itemSummary = "・\(productName) x\(quantity) ¥\(cartItem.productPrice)"
                        orderSummary += itemSummary + "\n"
                    }
                }
            }
        }
        
        print(orderSummary)  // 結果を表示
         商品リストを生成

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
