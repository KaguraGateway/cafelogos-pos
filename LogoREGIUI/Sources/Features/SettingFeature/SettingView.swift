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
                            .foregroundStyle(.secondary)
                    }
                    HStack(alignment: .center) {
                        Text("クライアント名")
                        Spacer()
                        TextField("クライアント名", text: $store.clientName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack(alignment: .center) {
                        Text("ホストURL")
                        Spacer()
                        TextField("", text: $store.hostUrl)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .foregroundStyle(.secondary)
                    }
                    HStack(alignment: .center) {
                        Text("管理画面URL")
                        Spacer()
                        TextField("", text: $store.adminUrl)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .foregroundStyle(.secondary)
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
                            .disabled(store.printTicket)
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
                        Toggle("チケット番号発行", isOn: $store.useClientTicketNumbering)
                    }
                } header: {
                    Text("印刷設定")
                }
                Section {
                    Toggle("Squareターミナル利用", isOn : $store.isUseSquareTerminal )
                    if store.isUseSquareTerminal {
                        HStack(alignment: .center) {
                            Text("SQUARE_ACCESS_TOKEN")
                            Spacer()
                            TextField("", text: $store.squareAccessToken)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack(alignment: .center) {
                            Text("SQUARE_TERMINAL_DEVICE_ID")
                            Spacer()
                            TextField("", text: $store.squareTerminalDeviceId)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                } header: {
                    Text("外部機器設定")
                }
                
                Section {
                    Toggle("商品モックを有効化", isOn: $store.isUseProductMock)
                    Toggle("個別会計を有効にする", isOn: $store.isUseIndividualBilling)
                } header: {
                    Text("開発設定")
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
