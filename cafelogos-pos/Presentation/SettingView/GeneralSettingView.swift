//
//  GeneralSettingView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/22.
//

import SwiftUI

struct GeneralSettingView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    @State private var usePrinter = true
    @State private var printReceipt = true
    @State private var printTicket = true
    @State private var useDrawer = true
    @State private var isLogoutDisabled = true
    
    @ObservedObject var viewModel = GeneralSettingViewModel()
    
    var body: some View {
            
                Form {
                    Section {
                        NavigationLink(destination: {
                            DeviceNameInputView(clientName: $viewModel.clientName)
                        }, label: {
                            HStack(alignment: .center){
                                Text("端末名")
                                Spacer()
                                Text(viewModel.clientName)
                                    .foregroundColor(.secondary)
                            }
                        })
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
                            Toggle("会計レシート印刷", isOn : $printReceipt)
                            if printReceipt{
                                Button(action: {}) {
                                    Text("会計レシート印刷テスト")
                                        .foregroundStyle(Color.blue)
                                }
                                .padding(.leading)
                            }
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
            
            .padding(.horizontal ,120)
            .background(Color(.secondarySystemBackground))
            .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}


struct GeneralSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingView()
            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad (9th generation)")
//            .previewDevice("iPad mini (6th generation)")
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
