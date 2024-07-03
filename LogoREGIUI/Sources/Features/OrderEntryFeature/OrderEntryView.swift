//
//  OrderEntryView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/06.
//

import SwiftUI
import Algorithms
import StarIO10
import LogoREGICore
import ComposableArchitecture

struct OrderEntryView: View {
    @Bindable var store: StoreOf<OrderEntryFeature>
    
    @ObservedObject private var viewModel = OrderEntryViewModel()
    // ホームに戻るための状態管理フィールド
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader{geometry in
            ContainerWithNavBar {
                VStack(spacing: 0){
                    HStack(spacing:0){
                        ProductStack(
                            productCategories: viewModel.categoriesWithProduct,
                            onAddItem: viewModel.addItem
                        )
                        .padding(.leading, 10)
                        .frame(width: geometry.size.width * 0.6)
                        Divider()
                        DiscountStack(discounts: viewModel.discounts, onTapDiscount: viewModel.onTapDiscount)
                            .frame(width: geometry.size.width * 0.1)
                        Divider()
                        OrderEntryStack(
                            cartItems: viewModel.order.cart.items,
                            discounts: viewModel.order.discounts,
                            onTapDecreaseBtn: viewModel.onTapDecrease,
                            onTapIncreaseBtn: viewModel.onTapIncrease,
                            onRemoveItem: viewModel.onRemoveItem
                        )
                        .frame(width: geometry.size.width * 0.3)
                    }
                    EntryBottomBar(
                        order: viewModel.order, onRemoveAllItem: viewModel.onRemoveAllItem
                    )
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink{
                            HomeView()
                        } label:{
                            Text("ホームへ戻る")
                        }
                    }
                }
            }
        }
        .task {
            await self.viewModel.fetch()
        }
    }
}


// ここから注文リストのボタン




#Preview {
    OrderEntryView(
        store: .init(initialState: .init()) {
            OrderEntryFeature()
        })
}

