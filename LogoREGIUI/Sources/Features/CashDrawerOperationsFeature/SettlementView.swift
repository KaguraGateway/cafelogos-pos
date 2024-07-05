// 精算画面

import SwiftUI
import LogoREGICore

// サンプルデータ
struct ChargenData {
    var denomination: Int
    var quantity: Int
    var amount: Int
}

struct SettlementView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @ObservedObject var viewModel = SettlementViewModel()
    
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "精算"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(denominations: $viewModel.current)
                    Divider()
                    VStack(alignment: .leading){
                        TitledAmountView(title: "あるべき釣り銭(A)", amount: viewModel.shouldTotal())
                            .padding(.bottom)
                            .padding(.top, 50)
                        TitledAmountView(title: "現在の釣り銭(B)", amount: viewModel.currentTotal())
                            .padding(.bottom)
                        TitledAmountView(title: "誤差(B-A)", amount: viewModel.diffAmount())
                        Spacer()
                        TitleNavButton(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView()})
                            .simultaneousGesture(TapGesture().onEnded {
                                viewModel.complete()
                            })
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct SettlementView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementView()
            .previewInterfaceOrientation(.landscapeRight)
        //            .previewDevice("iPad (9th generation)")
        //            .previewDevice("iPad mini (6th generation)")
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
