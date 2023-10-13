//
//  InspectionViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/07.
//

import Foundation

class InspectionViewModel: ObservableObject {
    @Published var current = Denominations()
    @Published var should = Denominations()
    
    init() {
        should = GetDenominations().Execute()
    }
    
    func currentTotal() -> Int {
        return Int(current.total())
    }
    
    func shouldTotal() -> Int {
        return Int(should.total())
    }
    
    func diffAmount() -> Int {
        return currentTotal() - shouldTotal()
    }
}
