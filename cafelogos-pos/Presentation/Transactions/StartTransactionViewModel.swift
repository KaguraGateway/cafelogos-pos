//
//  StartTransactionViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation

class StartTransactionViewModel: ObservableObject {
    @Published var denominations = Denominations()
    
    init() {
        denominations = GetDenominations().Execute()
    }
    
    func totalAmount() -> UInt64 {
        return denominations.total()
    }
    
    func onNextAction() {
        StartCacher().Execute(denominations: denominations)
    }
}
