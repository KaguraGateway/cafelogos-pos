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
        case ordersList(OrdersListFeature)
        case cashDrawerHistory(CashDrawerHistoryFeature)
        case paymentList(PaymentListFeature)
    }
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>();
        var isServerConnected = false;
        var useCashDrawer = true; // Configに使用可否を保存できるようになったら連携する
        
        public init() {}
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case popToHome
        case setIsServerConnected(Bool)
        case setUseCashDrawer(Bool)
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

                // 決済完了後に注文入力画面に戻る
                case .element(id: _, action: .paymentSuccess(.navigateToTapOrderEntry)):
                    state.path.removeAll() // 前の注文の決済完了画面への遷移を防ぐため
                    state.path.append(.orderEntry(OrderEntryFeature.State()))
                    return .none

                // ホームに戻るケース
                case .element(id: _, action: .cashDrawerClosing(.alert(.presented(.settlementOkTapped)))):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerInspection(.completeInspection)):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerSetup(.skipStartingCahierTransaction)):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerSetup(.alert(.presented(.okTapped)))):
                    return .send(.popToHome)
                case .element(id: _, action: .orderEntry(.popToRoot)):
                    return .send(.popToHome)
                case .element(id: _, action: .ordersList(.popToRoot)):
                    return .send(.popToHome)
                case .element(id: _, action: .cashDrawerHistory(.popToRoot)):
                    return .send(.popToHome)
                case let .element(id: _, action: .orderEntry(.setIsServerConnected(isConnected))):
                    return .send(.setIsServerConnected(isConnected))
                default:
                    return .none
                }
            case .popToHome:
                state.path.removeAll()
                return .none
            case let .setIsServerConnected(isConnected):
                state.isServerConnected = isConnected;
                return .none
            case let .setUseCashDrawer(isDrawerUse): // 変数名が被った、変更可能な時にuseDrawerに変更したい
                state.useCashDrawer = isDrawerUse;
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
