import SwiftUI
import ComposableArchitecture

struct CashDrawerButton: View {
    @Bindable var store: StoreOf<CashDrawerButtonFeature>
    
    public init(store: StoreOf<CashDrawerButtonFeature>) {
        self.store = store
    }
    
    var body: some View {
        Button(action: {
            store.send(.openCashDrawer)
        }) {
            Text("ドロアを開く")
        }
    }
}
