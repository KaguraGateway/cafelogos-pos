import SwiftUI
import ComposableArchitecture

struct UIKitTestView: View {
    let store: StoreOf<UIKitTestFeature>
    
    var body: some View {
        ContainerWithNavBar {
            VStack(spacing: 20) {
                UIKitSampleView(title: store.title)
                    .frame(height: 60)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    store.send(.updateTitle("タイトルを更新しました"))
                }) {
                    Text("タイトルを更新")
                        .frame(width: 200, height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("UIKit統合テスト")
    }
}

#Preview {
    UIKitTestView(
        store: Store(initialState: UIKitTestFeature.State()) {
            UIKitTestFeature()
        }
    )
}
