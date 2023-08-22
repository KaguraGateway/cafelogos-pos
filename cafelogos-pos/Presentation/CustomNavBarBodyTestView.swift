//
//  CustomNavBarBodyTestView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/14.
//

import SwiftUI

// 表示する構造体
struct CustomNavBarBodyTestView: View {
    @State private var displayConnection: Bool = false // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    var body: some View {
        CustomNavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム") {
                VStack(spacing: 0) {
                    // 全体
                    Divider()
                    // mainStack
                    HStack(alignment: .top, spacing: 20) {
                        // 左列
                        VStack(spacing: 20.0) {
                            LeftButton(title: "注文入力・会計", subtitle: "（イートイン管理なし）", description: "POSレジのみから注文を入力・管理する")
                            LeftButton(title: "注文入力・会計", subtitle: "（イートイン管理あり）", description: "POSレジ・ハンディ端末から注文を管理する")
                        }
                        // 右列
                        VStack(spacing: 20.0) {
                            RightButton(title: "点検", subtitle: "", description: "")
                            RightButton(title: "精算", subtitle: "", description: "")
                            RightButton(title: "設定", subtitle: "", description: "")
                            RightButton(title: "トレーニング", subtitle: "オン・オフ切り替え", description: "")
                            
                            
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    Spacer()
                }
            }
    }
}

// カスタムナビゲーションバーを含むコンポーネント
struct CustomNavBarBody <Content: View>: View {
    @Binding var displayConnection: Bool
    @Binding var serverConnection: Bool
    let content: Content
    let title: String
    
    init(displayConnection: Binding<Bool>, serverConnection: Binding<Bool>, title: String, @ViewBuilder content: () -> Content) {
        self._displayConnection = displayConnection
        self._serverConnection = serverConnection
        self.title = title
        self.content = content()
    }
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 10) {
                            VStack(alignment: .center) {
                                Image(systemName: displayConnection ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(displayConnection ? .green : .red)
                                Text("料金モニター")
                                    .foregroundColor(displayConnection ? .green : .red)
                            }
                            
                            VStack {
                                Image(systemName: serverConnection ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(serverConnection ? .green : .red)
                                Text("サーバー通信")
                                    .foregroundColor(serverConnection ? .green : .red)
                            }
                        }
                    }
                }
        }
    }
}
struct CustomNavBarBodyTestView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarBodyTestView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
