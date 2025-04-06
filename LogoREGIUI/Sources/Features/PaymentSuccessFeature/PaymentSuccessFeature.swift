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
        let callNumber: String
        let totalQuantity: UInt32
        let totalAmount: UInt64
        
        public init(payment: Payment, orders: [Order], callNumber: String, totalQuantity: UInt32, totalAmount: UInt64) {
            self.payment = payment
            self.orders = orders
            self.callNumber = callNumber
            self.totalQuantity = totalQuantity
            self.totalAmount = totalAmount
            print("aaaa")
        }
    }
    
    public enum Action {
        case onApper
        case navigateToTapOrderEntry
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onApper:
                // ToDo:
                // PaymentFeature.State.payment取得
                    // お釣り：changeAmount（おつり）もわかる
                    // 合計金額：paymentAmount（合計金額）
                    // 受け取った金額：receiveAmount（あずかり）
                // PaymentFeature.State.order取得
                    // 商品点数：totalAmount
                    // totalQuantityを持ってくる
                    // 割引の数：discountsをcountする
                    
                // PaymentFeature.State.callNumber取得
                    // 引換券番号わかる
                // AppFeatureからappendする
                    // 実装例 https://github.com/pointfreeco/swift-composable-architecture/blob/main/Examples/CaseStudies/SwiftUICaseStudies/04-NavigationStack.swift
                // それぞれStateに代入
                return .none
                
            case .navigateToTapOrderEntry:
                // OrderEntryへの遷移
                return .run { _ in
                    @Dependency(\.customerDisplay) var customerDisplay
                    customerDisplay.updateOrder(orders: [Order()])
                }
            }
        }
    }
}
