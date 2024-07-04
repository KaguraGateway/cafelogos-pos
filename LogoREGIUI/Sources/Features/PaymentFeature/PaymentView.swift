import SwiftUI
import ComposableArchitecture


struct PaymentView: View {
    @Bindable var store: StoreOf<PaymentFeature>
    
    public init(store: StoreOf<PaymentFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ContainerWithNavBar {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 0) {
                    OrderListView(orders: store.orders)
                    ScrollView {
                        // TODO: 割引リスト
                    }
                    .frame(width: 120)
                    VStack(spacing:0){
                        Text("合計金額")
                            .padding(.top, 15)
                            .font(.title2)
                        Text("¥\(store.totalAmount)")
                            .font(.system(size: 60, weight: .semibold, design: .default))
                            .padding(.vertical, 20)
                        HStack(){
                            Text("現金")
                                .font(.title)
                            Text("¥\(store.payment.receiveAmount)")
                                .font(.system(.largeTitle, weight: .semibold))
                            Spacer()
                                .frame(maxWidth: 50)
                            // 不足している場合は「不足　¥〇〇」の表記になる
                            if store.payment.isEnoughAmount() {
                                Text("おつり")
                                    .font(.title)
                                Text("¥\(store.payment.changeAmount)")
                                    .font(.system(.largeTitle, weight: .semibold))
                            } else {
                                Text("不足")
                                    .font(.title)
                                    .foregroundColor(.red)
                                Text("¥-\(store.payment.shortfallAmount)")
                                    .font(.system(.largeTitle, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.bottom, 10)
                        Divider()
                        NumericKeyboardView(store: store.scope(state: \.numericKeyboardState, action: \.numericKeyboardAction))
                    }
                    .frame(width: 500)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(spacing: 0) {
                    BottomBarView(
                        totalQuantity: store.totalQuantity,
                        payment: store.payment,
                        onTapPay: {
                            store.send(.onTapPay)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            .alert($store.scope(state: \.alert, action: \.alert))
        }
        .navigationTitle("支払い")
    }
}
