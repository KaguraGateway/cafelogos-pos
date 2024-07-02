//
//  NavigationBarFeature.swift
//
//
//  Created by Owner on 2024/07/02.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NavigationBarFeature {
    @ObservableState
    struct State {
        var displayConnection: Bool = true
        var serverConnection: Bool = true
        var title: String = ""
    }

    enum Action {
            case onAppear
            case setServerConnection
            case setTitle(String)
            case openDrawer
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .setServerConnection:
                state.serverConnection.toggle()
                return .none
                
            case let .setTitle(newTitle):
                state.title = newTitle
                return .none
                
            case .openDrawer:
                // ドロワー操作は別のFeatureに切り分けるべきという判断で実装見送り
                print("openDrawer")
                return .none
            }
        }
    }
}
