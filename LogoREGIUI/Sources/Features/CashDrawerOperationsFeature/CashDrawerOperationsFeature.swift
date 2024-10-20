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
        @Presents var alert: AlertState<Action.Alert>?
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

        // Alert
        case alert(PresentationAction<Action.Alert>)
        
        @CasePathable
        public enum Alert {
            case okTapped
            case settlementOkTapped
            case cancel
        }
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
                
            // レジ締め
            case .completeSettlement:
                state.alert = AlertState {
                    TextState("精算確認")
                } actions: {
                    ButtonState(action: .settlementOkTapped) {
                        TextState("OK")
                    }
                    ButtonState(action: .cancel) {
                        TextState("キャンセル")
                    }
                } message: {
                    TextState("現在の入力額で精算処理を行い、スクリーンショットを記録します。本当によろしいですか？")
                }
                return .none
                
            case .alert(.presented(let alertAction)):
                switch alertAction {
                case .okTapped:
                    // 画面遷移する
                    StartCacher().Execute(denominations: state.denominationFormListFeatureState.denominations)
                case .settlementOkTapped:
                    Settle().Execute(denominations: state.denominationFormListFeatureState.denominations)
                case .cancel:
                    print("Tapped Cancel")
                }
                // アラートを閉じる
                state.alert = nil
                return .none
                
            case .alert:
                return .none
            
            // レジ開け
            case .startCashierTransaction:
                state.alert = AlertState {
                    TextState("レジ開け確認")
                } actions: {
                    ButtonState(action: .okTapped) {
                        TextState("OK")
                    }
                    ButtonState(action: .cancel) {
                        TextState("キャンセル")
                    }
                } message: {
                    TextState("入力額は本当に合っていますか？今一度確認してください")
                }
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
        .ifLet(\.$alert, action: \.alert)
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
