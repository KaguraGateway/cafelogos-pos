//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/01
//  
//

import SwiftUI
import ComposableArchitecture

public struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>
    
    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ContainerWithNavBar {
                Text("Hello World")
            }
                .navigationTitle("App")
        } destination: { store in
            switch store.case {
            case let .payment(store):
                TmpPaymentView(store: store)
            }
        }
        .environment(\.isServerConnected, store.isServerConnected)
    }
}
