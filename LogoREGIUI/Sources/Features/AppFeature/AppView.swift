import SwiftUI
import ComposableArchitecture
import LogoREGICore
import Dependencies

public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
        // 初期化時にConfigからhostUrlを読み込む
        let config = GetConfig().Execute()
        store.send(.setHostUrl(config.hostUrl))
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomeView()
        } destination: { store in
            switch store.case {
            case let .printerTest(store):
                PrinterTestView(store: store)
            case let .settings(store):
                SettingView(store: store)
            case let .orderEntry(store):
                OrderEntryView(store: store)
            case let .payment(store):
                PaymentView(store: store)
            case let .paymentSuccess(store):
                PaymentSuccessView(store: store)
            case let .cashDrawerClosing(store):
                CashDrawerClosingView(store: store)
            case let .cashDrawerSetup(store):
                CashDrawerSetupView(store: store)
            case let.cashDrawerInspection(store):
                InspectionView(store: store)
            }
        }
        .environment(\.isServerConnected, store.isServerConnected)
        .environment(\.useCashDrawer, store.useCashDrawer)
        .environment(\.hostUrl, store.hostUrl) // hostUrlのEnvironmentを追加
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UpdateHostUrl"))) { notification in
            if let hostUrl = notification.object as? String {
                store.send(.setHostUrl(hostUrl))
                // DependencyValuesのhostUrlも更新する
                HostUrlUpdater.updateHostUrl(hostUrl)
            }
        }
    }
}
