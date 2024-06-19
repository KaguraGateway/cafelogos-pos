//
//  InspectionView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/29.
//

import SwiftUI

struct InspectionView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    @State private var isTraining: Bool = false
    
    @ObservedObject var viewModel = InspectionViewModel()
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "点検"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    ChargeInputView(denominations: $viewModel.current)
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "あるべき釣り銭(A)", amount: viewModel.shouldTotal())
                            .padding(.bottom)
                            .padding(.top, 50)
                        ChargeInfo(title: "現在の釣り銭(B)", amount: viewModel.currentTotal())
                            .padding(.bottom)
                        ChargeInfo(title: "誤差(B-A)", amount: viewModel.diffAmount())
                        Spacer()
                        TitleButton(title: "点検完了", bgColor: Color.teal, fgColor: Color.white, destination: {HomeView()})
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
    }
}

#Preview {
    InspectionView()
        .previewInterfaceOrientation(.landscapeRight)
    //            .previewDevice("iPad (9th generation)")
    //            .previewDevice("iPad mini (6th generation)")
//        .previewDevice("iPad Pro (11-inch) (4th generation)")
}
