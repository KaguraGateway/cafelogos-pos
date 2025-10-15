// 支払い完了画面

// 左
    // お釣り
    // 商品点数
    // 割引の数
    // 合計金額
    // 受け取った金額
// 右
    // 引換券番号
    // OrderEntryへの遷移
import SwiftUI
import ComposableArchitecture
import LogoREGICore

struct PaymentSuccessView: View {
    @Bindable var store: StoreOf<PaymentSuccessFeature>
    
    var body: some View {
        ContainerWithNavBar() {
            Divider()
            HStack(spacing:0){
                //左
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        VStack(spacing:0){
                            Text("☑︎ お支払いを完了しました")
                                .font(.system(size:30 , weight: .semibold, design: .default))
                                .padding(.bottom, 20)
                                .foregroundStyle(.green)
                            Text("おつり")
                                .font(.system(size:40 , weight: .semibold, design: .default))
                                .foregroundStyle(.secondary)
                            Text("¥\(store.payment.changeAmount)")
                                .font(.system(size: 80, weight: .semibold, design: .default))
                                .background(alignment: .bottom) {
                                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                                        .fill(.orange)
                                        .frame(height: 10)
                                        .clipped()
                                        .offset(x: 0, y: 5)
                                }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        Divider()
                        VStack(alignment: .leading, spacing:0){
                            Text("注文リスト")
                                .font(.system(.title, weight: .semibold))
                                .padding(10)
                                .padding(.horizontal, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color(.systemFill))
                                }
                                .padding(.bottom, 30)
                            HStack(spacing:0){
                                Text("商品 ")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Text("\(store.totalQuantity)点")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("¥\(store.totalAmount)")
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                            HStack(spacing:0){
                                Text("割引 ")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Text("\(store.orders[0].discounts.count)点")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("-¥\(store.orders.first?.getTotalDiscountPrice())")
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                            .foregroundStyle(Color.red)
                            Divider()
                                .padding(.vertical, 20)
                            HStack(spacing:0){
                                Text("計")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("¥\(store.totalAmount)")
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                            HStack(spacing:0){
                                Text("現計")
                                    .font(.title)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("¥\(store.payment.receiveAmount)")
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                            
                            
                        }
                        .frame(height: geometry.size.height / 2)
                        .frame(maxWidth: 350)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                Divider()
                // 右
                GeometryReader { geometry in
                    VStack(spacing:0){
                        Spacer()
                        Text("呼び出し番号")
                            .font(.system(size:40 , weight: .semibold, design: .default))
                            .foregroundStyle(.secondary)
                        Text("\(store.callNumber)")
                            .font(.system(size: 150, weight: .semibold, design: .default))
                        Spacer()
                        Button {
                            store.send(.navigateToTapOrderEntry)
                        } label: {
                            VStack(spacing: 0) {
                                Text("注文入力・会計")
                                    .font(.system(.largeTitle, weight: .semibold))
                                    .lineLimit(0)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                            .clipped()
                            .padding(.vertical, 30)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.cyan)
                            }
                        }
                        .frame(width: geometry.size.width * 0.7)
                        
                        
                    }
                    .padding(.bottom, 130)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(.secondarySystemBackground))
        }
        .navigationTitle("お支払い完了")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
