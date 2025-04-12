//
//  OrderEntryView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/06.
//

import SwiftUI
import Algorithms
import LogoREGICore
import ComposableArchitecture

struct OrderEntryView: View {
    @Bindable var store: StoreOf<OrderEntryFeature>
    
    var body: some View {
        ContainerWithNavBar {
            GeometryReader{geometry in
                VStack(spacing: 0){
                    HStack(spacing:0){
                        ProductStackView(store: store.scope(state: \.productStackState, action: \.productStackAction))
                        .padding(.leading, 10)
                        .frame(width: geometry.size.width * 0.6)
                        Divider()
                        DiscountStack(
                            discounts: store.discounts,
                            onTapDiscount: {discount in
                                store.send(.onTapDiscount(discount))
                            }
                            )
                            .frame(width: geometry.size.width * 0.1)
                        Divider()
                        OrderEntryStack(
                            cartItems: store.order.cart.items,
                            discounts: store.order.discounts,
                            onTapDecreaseBtn: { item in
                                store.send(.onTapDecrease(item))
                            },
                            onTapIncreaseBtn: { item in
                                store.send(.onTapIncrease(item))
                            },
                            onRemoveItem: { item in
                                store.send(.onRemoveItem(item))
                            }
                        )
                        .frame(width: geometry.size.width * 0.3)
                    }
                    OrderBottomBarView(store: store.scope(state: \.orderBottomBarState, action: \.orderBottomBarAction))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
            }
            .onAppear {
                store.send(.onAppear)
                @Dependency(\.customerDisplay) var customerDisplay
                customerDisplay.updateOrder(orders: [store.order])
            }
        }
        .navigationTitle("注文入力")
        .alert($store.scope(state: \.alert, action: \.alert))
        .overlay(content: {
            if store.isLoading {
                ZStack {
                    Color(.systemBackground).opacity(0.7)
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("読み込み中")
                        .font(.headline)
                        .padding(.top, 50)
                }
            }
        })
    }
}



// Previewの中身貼り付ければ検証可能
#Preview {
    OrderEntryView(
        store: .init(initialState: .init()) {
            OrderEntryFeature()
        })
}

