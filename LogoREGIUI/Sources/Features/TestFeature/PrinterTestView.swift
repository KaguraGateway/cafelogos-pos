import SwiftUI
import ComposableArchitecture

struct PrinterTestView: View {
    let store: StoreOf<PrinterTestFeature>
    
    var body: some View {
        ContainerWithNavBar {
            Button(action: {
                store.send(.print)
            }) {
                Text("印刷＆ドロア開閉")
            }
        }
        .navigationTitle("Printer Test")
    }
}

#Preview {
    PrinterTestView(
        store: Store(initialState: PrinterTestFeature.State()) {
            PrinterTestFeature()
        }
    )
}
