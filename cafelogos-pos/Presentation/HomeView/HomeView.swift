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
    
    let homeDestinations: [HomeDestination<AnyView>] = [
        HomeDestination(title: "点検・精算", subTitle: "", description: "", destination: {AnyView(SettingView())}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDestination(title: "レジ開け", subTitle: "", description: "", destination: {AnyView(StartTransactionView())}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDestination(title: "設定", subTitle: "", description: "", destination: {AnyView(SettingView())}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDestination(title: "トレーニング", subTitle: "オン・オフ切り替え", description: "", destination: {AnyView(SettingView())}, fg_color: Color.primary, bg_color: Color(.systemFill)),
        HomeDestination(title: "トレーニング", subTitle: "オン・オフ切り替え", description: "", destination: {AnyView(SettingView())}, fg_color: Color.primary, bg_color: Color(.systemFill)),
    ]
    let gridItems = [
        GridItem(.adaptive(minimum: 100, maximum: 10000),spacing: 15,alignment: .top ),
        GridItem(.flexible(),spacing: 15,alignment: .top),
        GridItem(.flexible(),spacing: 15,alignment: .top),
        GridItem(.flexible(),spacing: 15,alignment: .top),
        //        GridItem(.flexible(),spacing: 15),
    ]
    
    
    
    
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
                            HomeNavButton(title: "注文入力・会計", subtitle: "（イートイン管理なし）", description: "POSレジのみから注文を入力・管理", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/2) , width: geometry.size.width * (1/3))
                            
                            HomeNavButton(title: "注文入力・会計", subtitle: "（イートイン管理あり）", description: "POSレジ・ハンディ端末から注文を管理", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/2) , width: geometry.size.width * (1/3))
                            
                        }
                        
                        // 右列
                        VStack(spacing: 15){
                            HomeNavButton(title: "点検", subtitle: "", description: "", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "精算", subtitle: "", description: "", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "設定", subtitle: "", description: "", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "トレーニング", subtitle: "", description: "オン・オフ切り替え", destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                        }
                    
                        LazyHGrid(rows: gridItems, spacing: 15 ) {
                            ForEach(homeDestinations.indices, id: \.self) { index in
                                HomeNavButton(
                                    title: homeDestinations[index].title,
                                    subtitle: homeDestinations[index].subTitle,
                                    description: homeDestinations[index].description,
                                    destination: {homeDestinations[index].destination()},
                                    fg_color: homeDestinations[index].fg_color,
                                    bg_color: homeDestinations[index].bg_color,
                                    height: geometry.size.height * (1/4),
                                    width: geometry.size.width * (1/3)
                                    
                                )
                                
                            }
                        }
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

