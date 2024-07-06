//
//  PaymentSuccessView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/20.
//

import SwiftUI
import StarIO10
import LogoREGICore

struct PaymentSuccessView: View {
    @ObservedObject var viewModel: PaymentSuccessViewModel
    
    public init(printer: StarPrinter?, payment: Payment, orders: [Order], callNumber: String) {
        viewModel = PaymentSuccessViewModel(printer: printer, payment: payment, orders: orders, callNumber: callNumber)
    }
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack() {
            VStack(spacing:0){
                Divider()
                HStack(spacing:0){
                    //左
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            VStack(spacing:0){
                                Text("☑︎ お支払いを完了しました")
                                    .font(.system(size:30 , weight: .semibold, design: .default))
                                    .padding(.bottom, 20)
                                    .foregroundColor(.green)
                                Text("おつり")
                                    .font(.system(size:40 , weight: .semibold, design: .default))
                                    .foregroundColor(.secondary)
                                Text("¥\(viewModel.payment.changeAmount)")
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
                                    Text("\(viewModel.totalQuantity())点")
                                        .font(.title)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("¥\(viewModel.totalCartAmount())")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                                HStack(spacing:0){
                                    Text("割引 ")
                                        .font(.title)
                                        .fontWeight(.medium)
                                    Text("\(viewModel.orders[0].discounts.count)点")
                                        .font(.title)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("-¥\(viewModel.payment.paymentAmount - viewModel.orders[0].cart.getTotalPrice())")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(Color.red)
                                Divider()
                                    .padding(.vertical, 20)
                                HStack(spacing:0){
                                    Text("計")
                                        .font(.title)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("¥\(viewModel.totalAmount())")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                                HStack(spacing:0){
                                    Text("現計")
                                        .font(.title)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("¥\(viewModel.payment.receiveAmount)")
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
                            .foregroundColor(.secondary)
                        Text("\(viewModel.callNumber)")
                            .font(.system(size: 150, weight: .semibold, design: .default))
                        Spacer()
                        NavigationLink{
                            // 遷移先を暫定的にContentViewにしています
                            ContentView()
                        } label:{
                            VStack(spacing: 0) {
                                Text("注文入力・会計")
                                    .font(.system(.largeTitle, weight: .semibold))
                                    .lineLimit(0)
                            }
                            .foregroundColor(.white)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        Button("支払い画面に戻る") {
                            //dismiss()
                        }
                    }
                }
            }
            
        }
    }
}
//
//struct PaymentSuccessView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentSuccessView(order: Order(id: "", cart: Cart(), discounts: [], payment: OrderPayment(type: PaymentType.cash, paymentAmount: 500, receiveAmount: 1000), orderAt: Date()), callNumber: "L-101")
//            .previewInterfaceOrientation(.landscapeRight)
////            .previewDevice("iPad (9th generation)")
////            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro (11-inch) (4th generation)")
//    }
//}
