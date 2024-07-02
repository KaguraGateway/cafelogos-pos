//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/02
//  
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct PaymentReducer {
    @ObservableState
    public struct State: Equatable {}
    
    public enum Action {
        case test
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
    
}

struct TmpPaymentView: View {
    let store: StoreOf<PaymentReducer>
    
    public init(store: StoreOf<PaymentReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Hello World")
    }
}
