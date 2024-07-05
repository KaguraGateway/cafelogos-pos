import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
struct DenominationFormListFeature {
    @ObservableState
    public struct State: Equatable {
        var denominations: Denominations
    }
    
    public enum Action {
        case updateDenomination(index: Int, newValue: Denomination)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateDenomination(index, newValue):
                state.denominations.denominations[index] = newValue
                return .none
            }
        }
    }
}
