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
        GeometryReader{geometry in
            ContainerWithNavBar {
                VStack(spacing: 0){
                    HStack(spacing:0){
                        ProductStack(
                            productCategories: store.categoriesWithProduct,
                            onAddItem: { product, brew in
                                store.send(.addItem(product, brew))
                            }
                        )
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
                    BottomBar(
                        order: store.order, 
                        onRemoveAllItem: {
                            store.send(.onRemoveAllItem)
                        }
                    )
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}



// Previewの中身貼り付ければ検証可能
#Preview {
    OrderEntryView(
        store: .init(initialState: .init()) {
            OrderEntryFeature()
        })
}

