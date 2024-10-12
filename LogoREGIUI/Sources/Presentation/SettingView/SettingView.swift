// 一般設定のView

import SwiftUI

struct SettingView: View {
    @State private var usePrinter = true
    @State private var printTicket = true
    @State private var useDrawer = true
    @State private var isLogoutDisabled = true
    
    @ObservedObject var viewModel = GeneralSettingViewModel()
    
    var body: some View {
        ContainerWithNavBar {
            Form {
                Section {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        Text("クライアントID")
                        Spacer()
                        Text(viewModel.clientId)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Toggle("プリンター利用", isOn : $usePrinter )
                    Toggle("キャッシュドロア利用", isOn : $useDrawer)
                    if useDrawer{
                        Button(action: {
                            viewModel.openCacher()
                        }) {
                            Text("ドロアを開く")
                                .foregroundStyle(Color.blue)
                        }
                        .padding(.leading)
                    }
                    
                } header: {
                    Text("レジ基本設定")
                }
                
                if usePrinter {
                    Section {
                        Toggle("引換券印刷", isOn : $printTicket)
                        if printTicket{
                            Button(action: {
                                viewModel.printReceipt()
                            }) {
                                Text("引換券印刷テスト")
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(.leading)
                        }
                    } header: {
                        Text("印刷設定")
                    }
                }
            }
        }
        .navigationTitle("設定")
            .padding(.horizontal ,120)
            .background(Color(.secondarySystemBackground))
            .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}
