//
//  cafelogos_posApp.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/08.
//

import SwiftUI

@main
struct cafelogos_posApp: App {
    public init() {
        Launch().Execute()
    }
    
    var body: some Scene {
        WindowGroup {
            StartTransactionView()
        }
    }
}
