// レジ開け画面

import SwiftUI
import ComposableArchitecture

struct CashDrawerSetupView: View {
    @ObservedObject var viewModel = StartTransactionViewModel()
//    @Bindable var store: StoreOf<CashDrawerOperationsFeature>
    
    
    var body: some View {
        ContainerWithNavBar {
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(denominations: $viewModel.denominations)
                    Divider()
                    VStack(alignment: .leading){
                        TitledAmountView(title: "釣り銭準備金", amount: Int(viewModel.totalAmount()))
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
        CashDrawerSetupView()
            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad (9th generation)")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
