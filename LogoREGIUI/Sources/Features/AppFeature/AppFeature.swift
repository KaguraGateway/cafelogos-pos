//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/03
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

