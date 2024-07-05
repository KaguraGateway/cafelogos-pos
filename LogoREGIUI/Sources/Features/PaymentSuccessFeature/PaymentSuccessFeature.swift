// 決済完了画面のFeature

import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct PaymentSuccessFeature {
    @ObservableState
    public struct State: Equatable {
        var payment: Payment
        var orders: [Order]
        var callNumber: String = ""
        var totalQuantity: UInt32 {
            orders.reduce(0) { $0 + $1.cart.totalQuantity }
        }
        
        var totalCartAmount: UInt64 {
            orders.reduce(0) { $0 + $1.cart.getTotalPrice() }
        }
        
        var totalAmount: UInt64 {
            orders.reduce(0) { $0 + $1.totalAmount }
        }
    }
    
    
    public enum Action {
        case onApper
        case onTapOrderEntry
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onApper:
                // 引換券番号の取得
                return .none
                
            case .onTapOrderEntry:
                // OrderEntryへの遷移
                return .none
            }
        }
    }
}
