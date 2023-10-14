//
//  PaymentView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/20.
//

import SwiftUI
import Algorithms
import StarIO10

let gridItems = [
    GridItem(.flexible(),spacing: 20),
    GridItem(.flexible(),spacing: 20),
    GridItem(.flexible(),spacing: 20),
]

//本体
struct PaymentView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @ObservedObject private var viewModel: PaymentViewModel
    
    public let printer: StarPrinter?
    public var newOrder: Order?
    public var orders: [Order]
    
    public init(printer: StarPrinter?, orders: [Order], newOrder: Order?) {
        self.printer = printer
        self.newOrder = newOrder
        self.orders = orders
        if newOrder != nil {
            self.orders.append(newOrder!)
        }
        self.viewModel = PaymentViewModel(orders: self.orders, newOrder: newOrder)
    }
    
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
                            ForEach(orders.indexed(), id: \.index) { (_, order) in
                                ForEach(order.cart.items.indexed(), id: \.index) { (index, item) in
                                    HStack{
                                        VStack(alignment: .leading, spacing:0){
                                            Text(item.coffeeHowToBrew != nil ? "\(item.productName) (\(item.coffeeHowToBrew!.name))" : item.productName)
                                                .lineLimit(0)
                                                .font(.system(.title2 , weight: .semibold))
                                            Text("\(item.getQuantity())"+"点")
                                                .padding(.top, 16)
                                        }
                                        .font(.title2)
                                        Spacer()
                                        Text("¥\(item.totalPrice)")
                                            .lineLimit(0)
                                            .font(.system(.title2 , weight: .semibold))
                                    }
                                    .padding(.vertical, 10)
                                    
                                }
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
                            Text("¥\(viewModel.totalAmount())")
                                .font(.system(size: 60, weight: .semibold, design: .default))
                                .padding(.vertical, 20)
                            HStack(){
                                Text("現金")
                                    .font(.title)
                                Text("¥\(viewModel.payment.receiveAmount)")
                                    .font(.system(.largeTitle, weight: .semibold))
                                Spacer()
                                    .frame(maxWidth: 50)
                                // 不足している場合は「不足　¥〇〇」の表記になる
                                if viewModel.isEnoughAmount() {
                                    Text("おつり")
                                        .font(.title)
                                    Text("¥\(viewModel.payment.changeAmount)")
                                        .font(.system(.largeTitle, weight: .semibold))
                                } else {
                                    Text("不足")
                                        .font(.title)
                                        .foregroundColor(.red)
                                    Text("¥-\(viewModel.payment.shortfallAmount)")
                                        .font(.system(.largeTitle, weight: .semibold))
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.bottom, 10)
                            Divider()
                            KeyboardView(onTapKeyboard: viewModel.onTapKeyboard)
                        }
                    }
                    .frame(width: 500)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(spacing: 0) {
                    Text("\(viewModel.totalQuantity())点")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                    Text("¥\(viewModel.payment.paymentAmount)")
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
                    Text("¥\(viewModel.payment.changeAmount)")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        Task {
                            await self.viewModel.onTapPay()
                        }
                    }){
                        Text("¥\(viewModel.payment.receiveAmount)で会計する")
                            .frame(width: 400)
                            .clipped()
                            .padding(.vertical)
                            .font(.system(.title2, weight: .bold))
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(viewModel.isEnoughAmount() ? .blue : .gray)
                            }
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.leading, 70)
                    }
                    .fullScreenCover(isPresented: $viewModel.showingSuccessSheet) {
                        PaymentSuccessView(printer: printer, payment: viewModel.payment, orders: viewModel.newOrder != nil ? [viewModel.newOrder!] : viewModel.orders, callNumber: viewModel.callNumber)
                    }
                    .disabled(!viewModel.isEnoughAmount())
                    
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
            .alert("サーバーへの送信に失敗しました", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.showingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "エラーメッセージがありません")
            }
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
        let onTapKeyboard: (String) -> Void

        var body: some View {
            VStack(spacing: 12) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { keytop in
                            CalcKey(keytop: keytop, action: {
                                onTapKeyboard(keytop)
                            })
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
//struct PaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentView(
//            order: Order(
//                cart: Cart(
//                    items: [
//                        CartItem(
//                            product: OtherProduct(
//                                productName: "レモネード",
//                                productId: "",
//                                productCategory: ProductCategory(id: "", name: "", createdAt: Date(), updatedAt: Date(), syncAt: nil),
//                                price: 500,
//                                stock: Stock(name: "", id: "", quantity: 10, createdAt: Date(), updatedAt: Date(), syncAt: nil),
//                                isNowSales: true,
//                                createdAt: Date(),
//                                updatedAt: Date(),
//                                syncAt: nil
//                            ),
//                            quantity: 5
//                        )
//                    ]
//                ),
//                discounts: [],
//                payment: nil
//            )
//        )
//            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad Pro (11-inch) (4th generation)")
//    }
//}
