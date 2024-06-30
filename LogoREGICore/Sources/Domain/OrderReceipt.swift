//
//  OrderReceipt.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation

public struct OrderReceipt {
    public let callNumber: String
    
    public init(callNumber: String) {
        self.callNumber = callNumber
    }
}

protocol OrderReceiptService {
    func printReceipt(receipt: OrderReceipt) -> String
    func openCacher() -> String
}
