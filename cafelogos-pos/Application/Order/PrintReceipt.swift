//
//  PrintReceipt.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import Dependencies

public struct PrintReceipt {
    @Dependency(\.orderReceipt) var orderReceiptService
    
    func Execute(receipt: OrderReceipt) -> String {
        return orderReceiptService.printReceipt(receipt: receipt)
    }
}
