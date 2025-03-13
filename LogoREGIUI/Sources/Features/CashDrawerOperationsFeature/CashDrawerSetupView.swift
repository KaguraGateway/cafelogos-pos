// レジ開け画面

import SwiftUI
import ComposableArchitecture

struct CashDrawerSetupView: View {
    @Bindable var store: StoreOf<CashDrawerOperationsFeature>
    
    var body: some View {
        ContainerWithNavBar {
            GeometryReader {geometry in
                HStack(spacing:0){
                    DenominationFormList(
                        store: store.scope(state: \.denominationFormListFeatureState, action: \.denominationFormListFeatureAction),
                        onFocusChange: { isFocused, index in store.send(.updateTextFieldFocus(isFocused, index)) }
                    )
                    Divider()
                    VStack(alignment: .leading){
                        TitledAmountView(title: "釣り銭準備金", amount: Int(store.cashDrawerTotal))
                            .padding(.bottom)
                            .padding(.top, 50)
                            
                        // テンキーを追加（フォーカス時のみ表示）
                        if store.isTextFieldFocused {
                            CashDrawerNumericKeyboardView(store: store.scope(state: \.numericKeyboardState, action: \.numericKeyboardAction))
                                .transition(.opacity)
                                .animation(.easeInOut, value: store.isTextFieldFocused)
                        }
                            
                        Spacer()
                        TitleNavButton(title: "スキップ",bgColor: Color.secondary, fgColor: Color.white)
                            .simultaneousGesture(TapGesture().onEnded {
                                store.send(.skipStartingCahierTransaction)
                            })

                        TitleNavButton(title: "レジ開け完了", bgColor: Color.cyan, fgColor: Color.white)
                            .simultaneousGesture(TapGesture().onEnded {
                                // 描画しているUIViewを取得して渡してスクリーンショットを撮る
                                if let windowScene = UIApplication.shared.connectedScenes
                                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                                   let rootView = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController?.view {
                                    store.send(.takeScreenshot(rootView))
                                }
                                store.send(.startCashierTransaction)
                            })
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .navigationTitle("レジ開け")
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    CashDrawerSetupView(store: .init(initialState: .init(), reducer: {
        CashDrawerOperationsFeature()
    }))
}
