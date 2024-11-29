// レシート印刷用データモデル

import Foundation

public struct ReceiptItem {
    public let name: String
    public let brewMethod: String?
    public let quantity: Int
    public let price: Int
    
    init(name: String, brewMethod: String?, quantity: Int, price: Int) {
        self.name = name
        self.brewMethod = brewMethod
        self.quantity = quantity
        self.price = price
    }
}
