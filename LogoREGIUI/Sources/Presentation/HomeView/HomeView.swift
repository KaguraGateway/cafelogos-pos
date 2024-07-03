//
//  HomeView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/14.
//

import SwiftUI
import LogoREGICore

struct HomeView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    
    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム") {
            VStack(spacing: 0) {
                // 全体
                Divider()
                // mainStack
                GeometryReader {geometry in
                    HStack(alignment: .top, spacing: 15) {
                        // 左列
                        
                        VStack(spacing: 15) {
                            // 遷移先を暫定的にContentViewにしています
                            HomeNavButton(title: "注文入力・会計", subtitle: "（イートイン管理対応）", description: "POSレジ・ハンディ端末から注文を管理", destination: {ContentView()}, fg_color: Color.primary, bg_color: Color(.secondarySystemFill), height: geometry.size.height , width: geometry.size.width * (1/3))
                        }
                        
                        // 右列
                        VStack(alignment: .leading, spacing: 15){
                            HomeNavButton(title: "点検", subtitle: "", description: "レジ内の釣り銭を差分を確認", destination: {InspectionView()}, fg_color: Color.primary, bg_color: Color(.tertiarySystemFill), height: geometry.size.height * (1/3) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "精算", subtitle: "", description: "レジ内の釣り銭を差分を確認・保存", destination: {SettlementView()}, fg_color: Color.primary, bg_color: Color(.tertiarySystemFill), height: geometry.size.height * (1/3) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "設定", subtitle: "", description: "レジ・プリンターの動作や表示をカスタマイズ", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.tertiarySystemFill), height: geometry.size.height * (1/3) , width: geometry.size.width * (1/3))
                        }

                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .background(){
                        GeometryReader {geometry in
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}
    
    
    struct HomeDestination<Destination> where Destination : View {
        var title: String
        var subTitle: String
        var description: String
        var destination: () -> Destination
        var fg_color: Color
        var bg_color: Color
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .previewInterfaceOrientation(.landscapeRight)
                            .previewDevice("iPad Pro (11-inch) (4th generation)")
//                .previewDevice("iPad (9th generation)")
        }
    }

