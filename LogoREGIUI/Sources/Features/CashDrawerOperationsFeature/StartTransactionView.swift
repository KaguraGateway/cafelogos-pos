// レジ開け画面

import SwiftUI

struct StartTransactionView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @ObservedObject var viewModel = StartTransactionViewModel()
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "レジ開け"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(denominations: $viewModel.denominations)
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "釣り銭準備金", amount: Int(viewModel.totalAmount()))
                            .padding(.bottom)
                            .padding(.top, 50)
                        Spacer()
                        TitleNavButton(title: "スキップ",bgColor: Color.secondary, fgColor: Color.white, destination: {HomeView()})
                        TitleNavButton(title: "レジ開け完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView()})
                            .simultaneousGesture(TapGesture().onEnded {
                                viewModel.onNextAction()
                            })
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

struct StartTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        StartTransactionView()
            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad (9th generation)")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
