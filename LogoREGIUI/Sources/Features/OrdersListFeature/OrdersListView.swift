import SwiftUI
import ComposableArchitecture
import LogoREGICore
import WebUI

struct OrdersListView: View {
    @Bindable var store: StoreOf<OrdersListFeature>
    
    var body: some View {
        ContainerWithNavBar {
            if !store.adminUrl.isEmpty {
                WebView(request: URLRequest(url: URL(string: store.adminUrl)!))
                    .refreshable()
                    .allowsBackForwardNavigationGestures(true)
            }
        }
        .navigationTitle("取引一覧")
        .alert($store.scope(state: \.alert, action: \.alert))
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    OrdersListView(
        store: .init(initialState: .init()) {
            OrdersListFeature()
        }
    )
}
