import SwiftUI
import ComposableArchitecture

public struct PopupNumericKeyboardView: View {
    public let store: StoreOf<CashDrawerNumericKeyboardFeature>
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Button(action: {
                    store.send(.onTapDoneButton)
                }) {
                    Text("完了")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing, 12)
            }
            
            CashDrawerNumericKeyboardView(store: store)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    PopupNumericKeyboardView(store: .init(initialState: CashDrawerNumericKeyboardFeature.State()) {
        CashDrawerNumericKeyboardFeature()
    })
}
