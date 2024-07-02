//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/01
//  
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct AppReducer {
    @Reducer(state: .equatable)
    public enum Path {
        case payment(PaymentReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>();
        
        public init() {}
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case popToHome
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                default:
                    return .none
                }
            case .popToHome:
                state.path.removeAll()
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}


public struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>
    
    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Text("Hello World")
        } destination: { store in
            switch store.case {
            case let .payment(store):
                TmpPaymentView(store: store)
            }
        }
    }
}
