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
// 消去ボタン
struct removeButton: View {
    public let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.red)
                    .frame(width: 40, height: 40)
                    .clipped()
                Image(systemName: "trash")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(Color(.systemGray6))
                    .fontWeight(.bold)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
// プラスボタン
struct increaseButton: View {
    let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.tertiaryLabel))
                    .frame(width: 40, height: 40)
                    .clipped()
                Image(systemName: "plus")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
// マイナスボタン
struct decreaseButton: View {
    let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.tertiaryLabel))
                    .frame(width: 40, height: 40)
                    .clipped()
                Image(systemName: "minus")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct OrderItemView: View {
    let name: String
    let quantity: UInt32
    let totalPrice: UInt64
    let onRemove: () -> Void
    let onDecrese: () -> Void
    let onIncrease: () -> Void
    
    var body: some View {
        VStack(spacing: 0){
            HStack(){
                Text(name)
                    .lineLimit(0)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                removeButton(onAction: {
                    onRemove()
                })
                .clipped()
            }
            .padding(.bottom, 20)
            HStack(spacing: 0){
                decreaseButton(onAction: {
                    onDecrese()
                })
                .clipped()
                Text("\(quantity)")
                    .padding(.horizontal, 10)
                    .lineLimit(0)
                    .font(.title2)
                    .fontWeight(.semibold)
                increaseButton(onAction: {
                    onIncrease()
                })
                .clipped()
                Spacer()
                Text("¥\(totalPrice)")
                    .lineLimit(0)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    OrderEntryView(
        store: .init(initialState: .init()) {
            OrderEntryFeature()
        })
}

