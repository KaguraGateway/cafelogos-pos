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
    var amount: Int
}
let items: [Item] = [
    Item(productName: "ハレノヒブレンド（ネル）", quantity: 3, amount: 200),
    Item(productName: "アツアツブレンド（アツアツアツアツアツアツアツアツアツアツアツアツアツアツ）", quantity: 2, amount: 150),
    Item(productName: "サザエ", quantity: 1, amount: 1000000000000000),
    Item(productName: "サザエ", quantity: 1000000000000000, amount: 100),
    Item(productName: "サザエ", quantity: 1, amount: 100),
    Item(productName: "サザエ", quantity: 1, amount: 100),
    Item(productName: "サザエ", quantity: 1, amount: 100),
    Item(productName: "サザエ", quantity: 1, amount: 100),
    Item(productName: "サザエ", quantity: 1, amount: 100),
    
]

let gridItems = [
    GridItem(.flexible(),spacing: 20),
    GridItem(.flexible(),spacing: 20),
    GridItem(.flexible(),spacing: 20),
]

//本体
struct PaymentView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    @State private var showingSuccessSheet = false
    
    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "支払い") {
            VStack(spacing: 0){
                Divider()
                // ここから
                HStack(spacing:0){
                    //注文リスト
                    VStack(spacing:0) {
                        Text("注文リスト")
                            .font(.system(.title, weight: .semibold))
                            .padding(.vertical, 10)
                        Divider()
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
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listStyle(PlainListStyle())
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
                        VStack(spacing:0){
                            Text("合計金額")
                                .padding(.top, 15)
                                .font(.title2)
                            Text("¥10,000")
                                .font(.system(size: 60, weight: .semibold, design: .default))
                                .padding(.vertical, 20)
                            HStack(){
                                Text("現金")
                                    .font(.title)
                                Text("¥5,000")
                                    .font(.system(.largeTitle, weight: .semibold))
                                Spacer()
                                    .frame(maxWidth: 50)
                                // 不足している場合は「不足　¥〇〇」の表記になる
                                Text("おつり")
                                    .font(.title)
                                Text("¥5,000")
                                    .font(.system(.largeTitle, weight: .semibold))
                            }
                            .padding(.bottom, 10)
                            Divider()
                            KeyboardView()
                        }
                    }
                    .frame(width: 500)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(spacing: 0) {
                    Text("5点")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                    Text("¥5000")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                        .padding(.leading)
                    Divider()
                        .frame(height: 50)
                        .background(Color.white)
                        .padding(.horizontal)
                    Text("おつり：")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                        .padding(.leading)
                    Text("¥5000")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.showingSuccessSheet.toggle()
                    }){
                        Text("¥5000で会計する")
                            .frame(width: 400)
                            .clipped()
                            .padding(.vertical)
                            .font(.system(.title2, weight: .bold))
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(.blue)
                            }
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.leading, 70)
                    }
                    .fullScreenCover(isPresented: $showingSuccessSheet) {
                        PaymentSuccessView()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background {
                    VStack {
                        Divider()
                        Spacer()
                    }
                }
                .background(.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
        }
    }
    
    struct KeyboardView: View {
        let rows: [[String]] = [
            ["¥1,000", "¥500", "⌫"],
            ["7", "8", "9"],
            ["4", "5", "6"],
            ["1", "2", "3"],
            ["0", "00", "000"]
        ]

        var body: some View {
            VStack(spacing: 12) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { keytop in
                            CalcKey(keytop: keytop)
                        }
                    }
                }
            }
            .padding(12)
        }
    }

    struct CalcKey: View {
        var keytop: String
        var action: () -> Void = {}

        var body: some View {
            Button(action: {
                action()
            }) {
                Text(keytop)
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(.systemFill))
                    )
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
