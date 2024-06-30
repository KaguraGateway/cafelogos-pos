//
//  OrderInputViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation

class OrderInputViewModel: ObservableObject {
    // 席番号からモーダルの表示bool
    @Published private (set) public var showingChooseOrder: Bool = false
    
    func showChooseOrder() {
        self.showingChooseOrder = true
    }
}
