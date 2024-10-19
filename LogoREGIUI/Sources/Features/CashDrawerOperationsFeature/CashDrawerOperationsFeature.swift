// レジ内釣り銭に関するFeature

import Foundation
import ComposableArchitecture
import LogoREGICore
import UIKit

@Reducer
public struct CashDrawerOperationsFeature {
    @ObservableState
    public struct State: Equatable {
        var cashDrawerTotal: Int = 0
        var expectedCashAmount: Int = 0
        var cashDiscrepancy: Int = 0
        
        var denominationFormListFeatureState = DenominationFormListFeature.State(denominations: Denominations())
    }
    
    
    public enum Action {
        case updateCashDrawerDenominations(Denominations)
        // 計算
        case calculateCashDrawerTotal
        case calculateExpectedCashAmount
        case calculateCashDiscrepancy
        // 精算
        case completeSettlement
        // レジ開け
        case startCashierTransaction
        case skipStartingCahierTransaction
        // 点検
        case completeInspection
        
        case denominationFormListFeatureAction(DenominationFormListFeature.Action)
        case takeScreenshot(UIView)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.denominationFormListFeatureState, action: \.denominationFormListFeatureAction) {
            DenominationFormListFeature()
        }
        Reduce { state, action in
            switch action {
            case let .updateCashDrawerDenominations(denominations):
                state.denominationFormListFeatureState.denominations = denominations
                return .send(.calculateCashDrawerTotal)
                
            case .calculateCashDrawerTotal:
                state.cashDrawerTotal = Int(state.denominationFormListFeatureState.denominations.total())
                return .send(.calculateCashDiscrepancy)
                
            case .calculateExpectedCashAmount:
                state.expectedCashAmount = Int(GetShouldHaveCash().Execute())
                return .send(.calculateCashDiscrepancy)
                
            case .calculateCashDiscrepancy:
                state.cashDiscrepancy = state.cashDrawerTotal - state.expectedCashAmount
                return .none
                
            case .completeSettlement:
                Settle().Execute(denominations: state.denominationFormListFeatureState.denominations)
                return .none
                
            case .startCashierTransaction:
                StartCacher().Execute(denominations: state.denominationFormListFeatureState.denominations)
                return .none
                
            case .skipStartingCahierTransaction:
                return .none

            case .completeInspection:
                return .none
                
                
            case .denominationFormListFeatureAction:
                return .send(.calculateCashDrawerTotal)
            case let .takeScreenshot(view):
                takeScreenshot(from: view)
                return .none
            }
            
        }
    }
    // スクリーンショットを撮る
    private func takeScreenshot(from view: UIView) {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        // アルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
