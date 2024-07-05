import SwiftUI
import ComposableArchitecture
import LogoREGICore

public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomeView()
        } destination: { store in
            switch store.case {
            case let .payment(store):
                PaymentView(store: store)
            case let .printerTest(store):
                PrinterTestView(store: store)
            }
        }
        .environment(\.isServerConnected, store.isServerConnected)
    }
}
