//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI
import ComposableArchitecture

// 下部バーのView
public struct OrderBottomBarView: View {
    @Bindable var store: StoreOf<OrderBottomBarFeature>
    
    public var body: some View{
        let screenWidth = UIScreen.main.bounds.size.width
        
        HStack(spacing: 0) {
            Text("\(store.newOrder?.cart.totalQuantity ?? 0)点")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
            Text("¥\(store.newOrder?.totalAmount ?? 0)")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Spacer()
            BottomBarButton(text: "伝票呼出", action: {
                store.send(.openChooseOrderSheet)
            }, bgColor: Color(.systemBackground), fgColor: Color.primary)
            .frame(width: 150, height: 60)
            .sheet(item: $store.scope(state: \.destination?.chooseOrderSheet, action: \.destination.chooseOrderSheet)) { store in
                ChooseOrderSheetView(store: store)
            }
            BottomBarButton(text: "注文全削除", action: {
                store.send(.delegate(.removeAllItem))
            }, bgColor: Color.red, fgColor: Color.white)
            .frame(width: 130, height: 60)
            .padding(.leading, 50)
            // 支払いへのNavigationLink
            NavigationLink(state: store.newOrder != nil ? AppFeature.Path.State.payment(PaymentFeature.State(newOrder: store.newOrder!)) : AppFeature.Path.State.payment(PaymentFeature.State(orders: store.orders))) {
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
        .onAppear {
            store.send(.delegate(.removeOrders))
        }
        
    }
}
