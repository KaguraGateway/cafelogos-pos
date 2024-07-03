//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI
import LogoREGICore

// 下部バーのView
struct EntryBottomBar: View {
    @State private var showingChooseOrder: Bool = false // 席番号からモーダルの表示bool
    @State private var orderNumber:String = ""
    @State private var orders: [Order] = [Order]()
    @State private var isOrderSheet = false
    public let order: Order?
    
    public let onRemoveAllItem: () -> Void
       
    var body:some View{
        let screenWidth = UIScreen.main.bounds.size.width
        
        HStack(spacing: 0) {
            Text("\(order?.cart.totalQuantity ?? 0)点")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
            Text("¥\(order?.totalAmount ?? 0)")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Spacer()
            BottomBarButton(text: "伝票呼出", action: {
                self.showingChooseOrder.toggle()
            }, bgColor: Color(.systemBackground), fgColor: Color.primary)
            .frame(width: 150, height: 60)
            .sheet(isPresented: $showingChooseOrder) {
                ChooseOrderSheet(orders: $orders, isOrderSheet: $isOrderSheet)
            }
            
            BottomBarButton(text: "注文全削除", action: {
                self.onRemoveAllItem()
            }, bgColor: Color.red, fgColor: Color.white)
            .frame(width: 130, height: 60)
            .padding(.leading, 50)
            // 支払いへのNavigationLink
            NavigationLink {
                PaymentView(printer: nil, orders: orders, newOrder: order)
            } label: {
                Text("支払いへ進む")
                    .frame(width: screenWidth * 0.27, height: 60)
                    .font(.system(.title2, weight: .bold))
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.blue)
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 50)
            }
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 15)
        .background(.primary)
        .navigationDestination(isPresented: $isOrderSheet) {
            PaymentView(printer: nil, orders: orders, newOrder: nil)
        }
        .onAppear {
            orders.removeAll()
        }
        
    }
}
