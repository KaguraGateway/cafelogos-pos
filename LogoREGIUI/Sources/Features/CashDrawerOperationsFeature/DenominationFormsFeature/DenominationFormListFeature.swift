import Foundation
import UIKit
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct DenominationFormListFeature {
    @ObservableState
    public struct State: Equatable {
        var denominations: Denominations
    }
    
    public enum Action {
        case updateDenomination(index: Int, newValue: Denomination)
        case delegate(Delegate)
        
        public enum Delegate {
            case registerTextField(UITextField, Int)
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateDenomination(index, newValue):
                state.denominations.denominations[index] = newValue
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
