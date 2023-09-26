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
    
    let homeDestinations: [HomeDistination] = [
        HomeDistination(title: "点検・精算", subTitle: "", description: "", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDistination(title: "レジ開け", subTitle: "", description: "", destination: {StartTransactionView()}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDistination(title: "設定", subTitle: "", description: "", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDistination(title: "トレーニング", subTitle: "オン・オフ切り替え", description: "", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        ]
    let gridItems = [
        GridItem(.flexible(),spacing: 20),
        GridItem(.flexible(),spacing: 20),
        GridItem(.flexible(),spacing: 20),
    ]
    
    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム") {
            VStack(spacing: 0) {
                // 全体
                Divider()
                // mainStack
                GeometryReader {geometry in
                    HStack(alignment: .top, spacing: 20) {
                        // 左列
                        
                        VStack(spacing: 20.0) {
                                HomeNavButton(title: "注文入力・会計", subtitle: "（イートイン管理なし）", description: "POSレジのみから注文を入力・管理", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill))
                                    .frame(maxWidth: geometry.size.width * 0.3, maxHeight: geometry.size.height * 0.5)
                                HomeNavButton(title: "注文入力・会計", subtitle: "（イートイン管理あり）", description: "POSレジ・ハンディ端末から注文を管理", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill))
                                    .frame(maxWidth: geometry.size.width * 0.3, maxHeight: geometry.size.height * 0.5)
                            }
                        
                        // 右列
                        VStack(spacing: 20.0) {
                                                    LazyVGrid(columns: gridItems) {
                                                        ForEach(homeDestinations.indices, id: \.self) { index in
                                                            HomeNavButton(
                                                                title: homeDestinations[index].title,
                                                                subtitle: homeDestinations[index].subTitle,
                                                                description: homeDestinations[index].description,
                                                                destination: {
                                                                    AnyView(homeDestinations[index].destination())
                                                                },
                                                                fg_color: homeDestinations[index].fg_color,
                                                                bg_color: homeDestinations[index].bg_color
                                                            )
                                                        }
                                                    }
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
    
    
    struct HomeDistination <Destination>: View where Destination : View {
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
//                .previewDevice("iPad Pro (11-inch) (4th generation)")
                        .previewDevice("iPad (9th generation)")
        }
    }
}
