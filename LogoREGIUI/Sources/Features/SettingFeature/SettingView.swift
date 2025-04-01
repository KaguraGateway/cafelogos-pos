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
                            .onChange(of: store.clientName) { _, _ in
                                store.send(.debouncedSaveConfig)
                            }
                    }
                    HStack(alignment: .center) {
                        Text("ホストURL")
                        Spacer()
                        TextField("", text: $store.hostUrl)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .foregroundStyle(.secondary)
                            .onChange(of: store.hostUrl) { _, _ in
                                store.send(.debouncedSaveConfig)
                            }
                    }
                    HStack(alignment: .center) {
                        Text("管理画面URL")
                        Spacer()
                        TextField("", text: $store.adminUrl)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .foregroundStyle(.secondary)
                            .onChange(of: store.adminUrl) { _, _ in
                                store.send(.debouncedSaveConfig)
                            }
                    }
                }
                Section {
                    Toggle("キャッシュドロア利用", isOn : $store.useDrawer)
                        .onChange(of: store.useDrawer) { _, _ in
                            store.send(.toggleValueChanged)
                        }
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
                        .onChange(of: store.usePrinter) { _, _ in
                            store.send(.toggleValueChanged)
                        }
                    if store.usePrinter {
                        Toggle("引換券印刷", isOn : $store.printTicket)
                            .onChange(of: store.printTicket) { _, _ in
                                store.send(.toggleValueChanged)
                            }
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
                            .onChange(of: store.printKitchenReceipt) { _, _ in
                                store.send(.toggleValueChanged)
                            }
                    }
                } header: {
                    Text("印刷設定")
                }
                Section {
                    Toggle("Squareターミナル利用", isOn : $store.isUseSquareTerminal )
                        .onChange(of: store.isUseSquareTerminal) { _, _ in
                            store.send(.toggleValueChanged)
                        }
                    if store.isUseSquareTerminal {
                        HStack(alignment: .center) {
                            Text("SQUARE_ACCESS_TOKEN")
                            Spacer()
                            TextField("", text: $store.squareAccessToken)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: store.squareAccessToken) { _, _ in
                                    store.send(.debouncedSaveConfig)
                                }
                        }
                        HStack(alignment: .center) {
                            Text("SQUARE_TERMINAL_DEVICE_ID")
                            Spacer()
                            TextField("", text: $store.squareTerminalDeviceId)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: store.squareTerminalDeviceId) { _, _ in
                                    store.send(.debouncedSaveConfig)
                                }
                        }
                    }
                } header: {
                    Text("外部機器設定")
                }
                
                Section {
                    Toggle("商品モックを有効化", isOn: $store.isUseProductMock)
                        .onChange(of: store.isUseProductMock) { _, _ in
                            store.send(.toggleValueChanged)
                        }
                    Toggle("個別会計を有効にする", isOn: $store.isUseIndividualBilling)
                        .onChange(of: store.isUseIndividualBilling) { _, _ in
                            store.send(.toggleValueChanged)
                        }
                } header: {
                    Text("開発設定")
                }
                
                Section {
                    Toggle("チケット番号を有効にする", isOn: $store.isUseTicketNumber)
                        .onChange(of: store.isUseTicketNumber) { _, _ in
                            store.send(.toggleValueChanged)
                        }
                    if store.isUseTicketNumber {
                        HStack(alignment: .center) {
                            Text("チケット番号プレフィックス")
                            Spacer()
                            TextField("", text: $store.ticketNumberPrefix)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: store.ticketNumberPrefix) { _, _ in
                                    store.send(.debouncedSaveConfig)
                                }
                        }
                        HStack(alignment: .center) {
                            Text("チケット番号開始番号")
                            Spacer()
                            TextField("", value: $store.ticketNumberStart, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: store.ticketNumberStart) { _, _ in
                                    store.send(.debouncedSaveConfig)
                                }
                        }
                    }
                } header: {
                    Text("チケット番号設定")
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
