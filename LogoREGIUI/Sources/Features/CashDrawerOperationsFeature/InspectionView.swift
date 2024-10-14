// 点検画面

import SwiftUI
import ComposableArchitecture

struct InspectionView: View {
    @Bindable var store: StoreOf<CashDrawerOperationsFeature>
    
    var body: some View {
        ContainerWithNavBar {
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
                        TitleNavButton(title: "点検完了", bgColor: Color.teal, fgColor: Color.white, destination: {HomeView()})
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .navigationTitle("点検")
    }
}

#Preview {
    InspectionView(store: .init(initialState: .init(), reducer: {
        CashDrawerOperationsFeature()
    }))
}
