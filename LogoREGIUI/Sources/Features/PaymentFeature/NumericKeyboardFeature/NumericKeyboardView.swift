import SwiftUI
import ComposableArchitecture

struct NumericKeyboardView: View {
    let store: StoreOf<NumericKeyboardFeature>
    
    let rows: [[String]] = [
        ["¥1,000", "¥500", "⌫"],
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["0", "00", "000"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { numericStr in
                        NumericButton(numericStr: numericStr, onAction: {
                            store.send(.onTapNumericButton(numericStr))
                        })
                    }
                }
            }
        }
        .padding(12)
    }
}

#Preview {
    NumericKeyboardView(store: .init(initialState: NumericKeyboardFeature.State()) {
            NumericKeyboardFeature()
    })
}
