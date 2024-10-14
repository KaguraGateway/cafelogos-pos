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
public struct AppFeature {
    @Reducer(state: .equatable)
    public enum Path {
        case printerTest(PrinterTestFeature)
        case settings(SettingsFeature)
        case orderEntry(OrderEntryFeature)
        case payment(PaymentFeature)
        case paymentSuccess(PaymentSuccessFeature)
        case cashDrawerClosing(CashDrawerOperationsFeature)
        case cashDrawerSetup(CashDrawerOperationsFeature)
        case cashDrawerInspection(CashDrawerOperationsFeature)
    }
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>();
        var isServerConnected = false;
        
        public init() {}
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case popToHome
        case setIsServerConnected(Bool)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                case let .element(id: _, action: .orderEntry(.navigatePaymentWithOrders(orders))):
                    state.path.append(.payment(PaymentFeature.State(orders: orders)))
                    return .none
                case let .element(id: _, action: .payment(.navigateToSuccess(payment, orders, callNumber, totalQuantity, totalAmout))):
                    state.path.append(.paymentSuccess(PaymentSuccessFeature.State(payment: payment, orders: orders, callNumber: callNumber, totalQuantity: totalQuantity, totalAmount: totalAmout)))
                    return .none
                case .element(id: _, action: .paymentSuccess(.navigateToTapOrderEntry)):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerClosing(.completeSettlement)):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerInspection(.completeInspection)):
                    return .send(.popToHome)
                default:
                    return .none
                }
            case .popToHome:
                state.path.removeAll()
                return .none
            case let .setIsServerConnected(isConnected):
                state.isServerConnected = isConnected;
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
