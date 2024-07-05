// レジ内釣り銭に関するFeature

import Foundation
import ComposableArchitecture
import LogoREGICore

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
        
        case denominationFormList(DenominationFormListFeature.Action)
    }
    
    public var body: some Reducer<State, Action> {
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
                
                
            case .denominationFormList:
                return .send(.calculateCashDrawerTotal)
            }
            
        }
    }
}
