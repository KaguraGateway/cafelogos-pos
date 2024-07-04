import Foundation
import ComposableArchitecture

@Reducer
public struct NumericKeyboardFeature {
    @ObservableState
    public struct State: Equatable {
        var inputNumeric: UInt64 = 0
    }
    
    public enum Action {
        case onTapNumericButton(String)
        case delegate(Delegate)
        
        public enum Delegate {
            case onChangeInputNumeric
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            print(action)
            switch action {
            case let .onTapNumericButton(inputStr):
                let prev = state.inputNumeric == 0 ? "" : String(state.inputNumeric)
                
                switch(inputStr) {
                case "¥1,000":
                    state.inputNumeric = 1000
                    break
                case "¥500":
                    state.inputNumeric = 500
                    break
                case "⌫":
                    state.inputNumeric = 0
                default:
                    if let newNumeric = UInt64("\(prev)\(inputStr)") {
                        state.inputNumeric = newNumeric
                    }
                }
                return .send(.delegate(.onChangeInputNumeric))
            case .delegate:
                return .none
            }
        }
    }
}
