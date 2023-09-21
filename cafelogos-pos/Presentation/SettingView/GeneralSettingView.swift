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
    @State private var deviceName = "カフェロゴスのiPad"
    @State private var usePrinter = false
    @State private var printReceipt = false
    @State private var printTicket = false
    @State private var useDrawer = false
    @State private var isLogoutDisabled = true
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "一般"){
            VStack(){
                Form {
                    Section {
                        NavigationLink(destination: {
                            DeviceNameInputViiew()                }, label: {
                                HStack(alignment: .center){
                                    Text("端末名")
                                    Spacer()
                                    Text(deviceName)
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    }
                    
                    Section {
                        Toggle("プリンター利用", isOn : $usePrinter )
                        Toggle("キャッシュドロア利用", isOn : $useDrawer)
                        if useDrawer{
                            Button(action: {}) {
                                Text("ドロアを開く")
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
                                }
                                .padding(.leading)
                            }
                            Toggle("引換券印刷", isOn : $printTicket)
                            if printTicket{
                                Button(action: {}) {
                                    Text("引換券印刷テスト")
                                }
                                .padding(.leading)
                            }
                        } header: {
                            Text("印刷設定")
                        }
                       }
                    
                    
                    
                    
                    Section {
                        Button(action: {}) {
                            Text("ログアウト")
                        }
                        .disabled(isLogoutDisabled)
                        .foregroundColor(isLogoutDisabled ? Color.gray : Color.red)
                    }
                }
            }
            .padding(.horizontal ,120)
            .background(Color(.secondarySystemBackground))
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            
            
        }
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
