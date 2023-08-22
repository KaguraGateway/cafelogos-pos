//
//  HomeView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/14.
//

import SwiftUI

struct HomeView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム") {
            VStack(spacing: 0) {
                // 全体
                Divider()
                // mainStack
                HStack(alignment: .top, spacing: 20) {
                    // 左列
                    VStack(spacing: 20.0) {
                        HomeMainButton(title: "注文入力・会計", subtitle: "（イートイン管理なし）", description: "POSレジのみから注文を入力・管理する", destination: {OrderInputView()})
                        HomeMainButton(title: "注文入力・会計", subtitle: "（イートイン管理あり）", description: "POSレジ・ハンディ端末から注文を管理する", destination: {OrderInputView()})
                    }
                    // 右列
                    VStack(spacing: 20.0) {
                        HomeSubButton(title: "点検", subtitle: "", description: "", destination: {OrderInputView()})
                        HomeSubButton(title: "精算", subtitle: "", description: "", destination: {OrderInputView()})
                        HomeSubButton(title: "設定", subtitle: "", description: "", destination: {OrderInputView()})
                        HomeSubButton(title: "トレーニング", subtitle: "オン・オフ切り替え", description: "", destination: {OrderInputView()})
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                Spacer()
            }
        }
    }
    
    
    // 左側ボタン、命名規則は特にない
    
    // 右側ボタン
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}
