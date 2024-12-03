import Foundation
import ComposableArchitecture

@Reducer
public struct NumericKeyboardFeature {
    @ObservableState
    public struct State: Equatable {
        var baseNumeric: UInt64 = 0     // 特定金額ボタン（¥500、¥1,000）で設定される値
        var suffixNumeric: String = "" // 数字ボタンで入力される値
        var inputNumeric: UInt64 {     // 合計金額
            baseNumeric + (UInt64(suffixNumeric) ?? 0)
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
                case "¥1,000":
                    state.baseNumeric = 1000
                    state.suffixNumeric = ""
                case "¥500":
                    state.baseNumeric = 500
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
                    // baseNumeric のリセット条件チェック、入力された固定値に応じて条件を変える
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
