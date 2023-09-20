//
//  PaymentView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/20.
//

import SwiftUI

//サンプルデータ
struct Item {
    var productName: String
    var quantity: Int
    var amount: Double
}
let items: [Item] = [
    Item(productName: "ハレノヒブレンド（ネル）", quantity: 3, amount: 200),
    Item(productName: "アツアツ", quantity: 2, amount: 150.0),
    Item(productName: "サザエ", quantity: 1, amount: 100.0),
]


//本体
struct PaymentView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中

    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム") {
            VStack(spacing: 0){
                Divider()
                // ここから
                HStack(spacing:0){
                    //注文リスト
                    VStack(spacing:0) {
                        Text("注文リスト")
                            .font(.system(.title, weight: .semibold))
                            .padding(.vertical, 10)
                        List {
                            ForEach(items.indices, id: \.self) { index in
                                HStack{
                                    VStack(alignment: .leading, spacing:0){
                                        Text(items[index].productName)
                                            .lineLimit(0)
                                            .font(.system(.title2 , weight: .semibold))
                                        Text("\(items[index].quantity)"+"点")
                                            .padding(.top, 16)
                                    }
                                    .font(.title2)
                                    Spacer()
                                    Text("¥\(items[index].amount)")
                                        .lineLimit(0)
                                        .font(.system(.title2 , weight: .semibold))
                                }
                                .padding(.vertical, 10)
                                
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    //割引リスト
                    // orderinputからコピー、@stateとか呼んでるやつとかわからんから適当に処理
                    ScrollView {
//                        LazyVGrid(columns: [GridItem(.flexible())]) {
//                            ForEach(discounts.indexed(), id: \.index) { (index, discount) in // Replace with your data model here
//                                Button(action: {
//
//                                }){
//                                    VStack(spacing: 0) {
//                                        Text(discount.name)
//                                            .font(.system(.title2, weight: .bold))
//                                            .padding(.vertical, 5)
//                                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
//                                            .clipped()
//                                            .lineLimit(2)
//                                            .multilineTextAlignment(.center)
//                                            .foregroundColor(.primary)
//                                        Text("-¥\(discount.discountPrice)")
//                                            .font(.system(.title2, weight: .regular))
//                                            .padding(.bottom, 10)
//                                            .foregroundColor(.primary)
//                                    }
//                                    .padding(.horizontal, 15)
//                                    .background {
//                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
//                                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
//                                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.secondary))
//                                    }
//                                    .frame(width: 100, height: 100)
//                                    .clipped()
//                                    .foregroundColor(Color(.systemBackground))
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.top, 20)
//
//                        .clipped()
                    }
                    .frame(width: 120) // 実装できたら消してね
                    // 電卓ゾーン
                    VStack(spacing:0) {
                        
                    }
                }
                
            }
        }
    }
    
    struct PaymentView_Previews: PreviewProvider {
        static var previews: some View {
            PaymentView()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}
