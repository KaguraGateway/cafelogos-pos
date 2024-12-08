//
//  cafelogos_posApp.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/08.
//

import SwiftUI
import LogoREGICore
import LogoREGIUI

@main
struct cafelogos_posApp: SwiftUI.App {
    public init() {
        // Launch
        Launch().Execute()
    }
    
    var body: some Scene {
        WindowGroup {
            // NOTE: Deep LinkのコードはAppViewの中にあります
            AppView(
                store: .init(initialState: .init()) {
                    AppFeature()
                })
        }
    }
}
