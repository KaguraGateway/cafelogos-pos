import Foundation
import ComposableArchitecture

@Reducer
public struct CashDrawerNumericKeyboardFeature {
    @ObservableState
    public struct State: Equatable {
        var baseNumeric: UInt64 = 0
        var suffixNumeric: String = ""
        var inputNumeric: UInt64 {
            baseNumeric + (UInt64(suffixNumeric) ?? 0)
        }
        var isPresented: Bool = false
        
        public init() {}
    }

    public enum Action {
        case onTapNumericButton(String)
        case onTapDoneButton
        case showKeyboard
        case hideKeyboard
        case delegate(Delegate)

        public enum Delegate {
            case onChangeInputNumeric
            case onDone
        }
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onTapNumericButton(inputStr):
                switch inputStr {
                case "⌫":
                    state.baseNumeric = 0
                    state.suffixNumeric = ""
                default:
                    // ゼロの入力処理
                    if inputStr == "0" || inputStr == "00" || inputStr == "000" {
                        if state.suffixNumeric.isEmpty {
                            break // suffixNumeric が空の場合、ゼロ入力を無視
                        } else {
                            state.suffixNumeric += inputStr // suffixNumeric にゼロを連結
                        }
                    } else {
                        state.suffixNumeric += inputStr // 通常の数字の連結
                    }
                }
                // 上限値のチェック
                if state.inputNumeric > 9999999 {
                    // 最新の入力を無視
                    if !state.suffixNumeric.isEmpty {
                        let lastInputLength = inputStr.count
                        state.suffixNumeric = String(state.suffixNumeric.dropLast(lastInputLength))
                    }
                }
                return .send(.delegate(.onChangeInputNumeric))
                
            case .onTapDoneButton:
                state.isPresented = false
                return .send(.delegate(.onDone))
                
            case .showKeyboard:
                state.isPresented = true
                return .none
                
            case .hideKeyboard:
                state.isPresented = false
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
