//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI
import LogoREGICore

// 注文リストのView
struct OrderEntryStack: View {
    public let cartItems: [CartItem]
    public let discounts: [Discount]
    public let onTapDecreaseBtn: (Int) -> Void
    public let onTapIncreaseBtn: (Int) -> Void
    public let onRemoveItem: (CartItem) -> Void
    
    public func getProductName(cartItem: CartItem) -> String {
        if(cartItem.coffeeHowToBrew != nil) {
            return "\(cartItem.productName) (\(cartItem.coffeeHowToBrew!.name)"
        }
        return cartItem.productName
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                Text("注文リスト")
                    .font(.system(.title, weight: .semibold))
                    .padding(.vertical, 10)
                Divider()
                List {
                    ForEach(cartItems.indexed(), id: \.index) { (index, cartItem) in
                        OrderItemView(
                            name: getProductName(cartItem: cartItem),
                            quantity: cartItem.getQuantity(),
                            totalPrice: cartItem.totalPrice,
                            onRemove: { onRemoveItem(cartItem) },
                            onDecrese: {onTapDecreaseBtn(index)},
                            onIncrease: {onTapIncreaseBtn(index)}
                        )
                    }
                    ForEach(discounts.indexed(), id: \.index) { (index, discount) in
                        OrderItemView(
                            name: discount.name,
                            quantity: 1,
                            totalPrice: UInt64(discount.discountPrice),
                            onRemove: {  },
                            onDecrese: { },
                            onIncrease: {}
                        )
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(PlainListStyle())
            }
            .frame(maxWidth: geometry.size.width)
        }
    }
}
