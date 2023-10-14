//
//  SettlementViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/07.
//

import Foundation

class SettlementViewModel: ObservableObject {
    @Published var current = Denominations()
    
    func currentTotal() -> Int {
        return Int(current.total())
    }
    
    func shouldTotal() -> Int {
        return Int(GetShouldHaveCash().Execute())
    }
    
    func diffAmount() -> Int {
        return currentTotal() - shouldTotal()
    }
    
    func complete() {
        Settle().Execute(denominations: current)
    }
}
