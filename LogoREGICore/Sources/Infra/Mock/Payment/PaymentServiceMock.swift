//
//  File.swift
//  LogoREGICore
//
//  Created by Owner on 2024/08/29.
//

import Foundation
import Dependencies

// オレオレエラー
enum MockError: Error {
    case mockFailure
}

// オレオレAPI
public struct PaymentServiceMock {
    @Dependency(\.cashierAdapter) var cashierAdapter
    @Dependency(\.configRepository) var configRepo
    
    // とりあえずstaticにすることでインスタンス間で値を共有
    private static var mockCallNumber: Int = 100
    
    public init() {}
    
    // mutableにすることでstruct内でインクリメントさせる
    public mutating func Execute(payment: Payment, postOrder: Order?) async -> NewPaymentOutput {
        if postOrder == nil {
            return NewPaymentOutput(callNumber: "", error: MockError.mockFailure)
        } else {
            let config = configRepo.load()
            PaymentServiceMock.mockCallNumber += 1
            if(config.isUsePrinter) {
                await cashierAdapter.openCacher()
                await cashierAdapter.printReceipt(receipt: OrderReceipt(callNumber: "L-\(PaymentServiceMock.mockCallNumber)"))
            }
        }
        return NewPaymentOutput(callNumber: "L-\(PaymentServiceMock.mockCallNumber)", error: nil)
        
    }
}

