// 精算画面

import SwiftUI
import LogoREGICore
import ComposableArchitecture

// サンプルデータ
struct ChargenData {
    var denomination: Int
    var quantity: Int
    var amount: Int
}

struct SettlementView: View {
    @Bindable var store: StoreOf<CashDrawerOperationsFeature>
    
    
    var body: some View {
        ContainerWithNavBar{
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(store: store.scope(state: \.denominationFormListFeatureState, action: \.denominationFormListFeatureAction))
                    Divider()
                    VStack(alignment: .leading){
                        TitledAmountView(title: "あるべき釣り銭(A)", amount: store.expectedCashAmount)
                            .padding(.bottom)
                            .padding(.top, 50)
                        TitledAmountView(title: "現在の釣り銭(B)", amount: store.cashDrawerTotal)
                            .padding(.bottom)
                        TitledAmountView(title: "誤差(B-A)", amount: store.cashDiscrepancy)
                        Spacer()
                        TitleNavButton(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView()})
                            .simultaneousGesture(TapGesture().onEnded {
                                store.send(.completeSettlement)
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

#Preview {
    SettlementView(store: .init(initialState: .init(), reducer: {
        CashDrawerOperationsFeature()
    }))
}
