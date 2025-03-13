// 精算画面

import SwiftUI
import ComposableArchitecture
import UIKit

// サンプルデータ
struct ChargenData {
    var denomination: Int
    var quantity: Int
    var amount: Int
}

struct CashDrawerClosingView: View {
    @Bindable var store: StoreOf<CashDrawerOperationsFeature>
    
    
    var body: some View {
        ContainerWithNavBar{
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(
                        store: store.scope(state: \.denominationFormListFeatureState, action: \.denominationFormListFeatureAction),
                        onFocusChange: { isFocused, index in store.send(.updateTextFieldFocus(isFocused, index)) }
                    )
                    Divider()
                    VStack(alignment: .leading){
                        TitledAmountView(title: "あるべき釣り銭(A)", amount: store.expectedCashAmount)
                            .padding(.bottom)
                            .padding(.top, 50)
                        TitledAmountView(title: "現在の釣り銭(B)", amount: store.cashDrawerTotal)
                            .padding(.bottom)
                        TitledAmountView(title: "誤差(B-A)", amount: store.cashDiscrepancy)
                        
                        Spacer()
                        TitleNavButton(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white)
                            .simultaneousGesture(TapGesture().onEnded {
                                // 描画しているUIViewを取得して渡してスクリーンショットを撮る
                                if let windowScene = UIApplication.shared.connectedScenes
                                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                                   let rootView = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController?.view {
                                    store.send(.takeScreenshot(rootView))
                                }
                                store.send(.completeSettlement)
                            })
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: Binding(
            get: { store.numericKeyboardState.isPresented && store.isTextFieldFocused },
            set: { newValue in
                if !newValue {
                    store.send(.numericKeyboardAction(.hideKeyboard))
                }
            }
        )) {
            PopupNumericKeyboardView(store: store.scope(state: \.numericKeyboardState, action: \.numericKeyboardAction))
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
                .presentationAlignment(.bottom)
        }
        .onAppear{
            store.send(.calculateExpectedCashAmount)
        }
        .navigationTitle("精算")
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    CashDrawerClosingView(store: .init(initialState: .init(), reducer: {
        CashDrawerOperationsFeature()
    }))
}
