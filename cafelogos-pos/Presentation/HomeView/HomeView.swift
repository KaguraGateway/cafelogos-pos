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
    @State private var isTraining: Bool = false
    
    init(isTraining: Bool) {
            self._isTraining = State(initialValue: isTraining)
        }
    
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
                        VStack(alignment: .leading, spacing: 15){
                            HomeNavButton(title: "点検", subtitle: "", description: "", destination: {InspectionView()}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "精算", subtitle: "", description: "", destination: {SettlementView()}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            HomeNavButton(title: "設定", subtitle: "", description: "", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/4) , width: geometry.size.width * (1/3))
                            TrainingStatus(isTraining: $isTraining)
                                .frame(maxWidth: geometry.size.width*(1/3), maxHeight: geometry.size.height * (1/4))
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
            HomeView(isTraining: false)
                .previewInterfaceOrientation(.landscapeRight)
                            .previewDevice("iPad Pro (11-inch) (4th generation)")
//                .previewDevice("iPad (9th generation)")
        }
    }

