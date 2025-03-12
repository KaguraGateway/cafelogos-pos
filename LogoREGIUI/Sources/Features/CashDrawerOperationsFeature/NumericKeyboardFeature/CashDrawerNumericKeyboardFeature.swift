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
        
        public init() {}
        
        // 右側の固定キーの値（1000円）
        var rightFixedKeyAmount: UInt64 {
            return 1000
        }
        
        // 左側の固定キーの値（500円）
        var leftFixedKeyAmount: UInt64 {
            return 500
        }
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
            switch action {
            case let .onTapNumericButton(inputStr):
                switch inputStr {
                case "¥\(state.leftFixedKeyAmount)":
                    state.baseNumeric = state.leftFixedKeyAmount
                    state.suffixNumeric = ""
                case "¥\(state.rightFixedKeyAmount)":
                    state.baseNumeric = state.rightFixedKeyAmount
                    state.suffixNumeric = ""
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
                    // baseNumeric のリセット条件チェック
                    let suffixLength = state.suffixNumeric.count
                    if (state.baseNumeric == 1000 && suffixLength >= 4) ||
                       (state.baseNumeric == 500 && suffixLength >= 3) {
                        state.baseNumeric = 0
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
            case .delegate:
                return .none
            }
        }
    }
}
