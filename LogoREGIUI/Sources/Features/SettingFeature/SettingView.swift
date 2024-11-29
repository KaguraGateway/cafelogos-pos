// 一般設定のView

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @Bindable var store: StoreOf<SettingsFeature>
    
    var body: some View {
        ContainerWithNavBar {
            Form {
                Section {
                    HStack(alignment: .center) {
                        Text("クライアントID")
                        Spacer()
                        Text(store.clientId)
                            .foregroundColor(.secondary)
                    }
                    HStack(alignment: .center) {
                        Text("クライアント名")
                        Spacer()
                        TextField("クライアント名", text: $store.clientName)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section {
                    Toggle("キャッシュドロア利用", isOn : $store.useDrawer)
                    if store.useDrawer{
                        Button(action: {
                            store.send(.openDrawer)
                        }) {
                            Text("ドロアを開く")
                                .foregroundStyle(Color.blue)
                        }
                        .padding(.leading)
                    }
                } header: {
                    Text("レジ基本設定")
                }
                Section {
                    Toggle("プリンター利用", isOn : $store.usePrinter )
                    if store.usePrinter {
                        Toggle("引換券印刷", isOn : $store.printTicket)
                            .padding(.leading)
                            .disabled(store.printTicket == true)
                        if store.printTicket{
                            Button(action: {
                                store.send(.printTicket)
                            }) {
                                Text("引換券印刷テスト")
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(.leading, 24)
                        }
                        Toggle("キッチンレシート印刷", isOn: $store.printKitchenReceipt)
                    }
                } header: {
                    Text("印刷設定")
                }
                
            }
        }
        .navigationTitle("設定")
        .padding(.horizontal ,120)
        .background(Color(.secondarySystemBackground))
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .onAppear{
            store.send(.onAppear)
        }
    }
}
