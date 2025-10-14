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
    public let discounts: [String: [Discount]]
    public let onTapDecreaseBtn: (Int) -> Void
    public let onTapIncreaseBtn: (Int) -> Void
    public let onRemoveItem: (CartItem) -> Void
    public let onTapDiscountDecreaseBtn: (Discount) -> Void
    public let onTapDiscountIncreaseBtn: (Discount) -> Void
    public let onRemoveDiscount: (Discount) -> Void
    public init(cartItems: [CartItem], discounts: [Discount], onTapDecreaseBtn: @escaping (Int) -> Void, onTapIncreaseBtn: @escaping (Int) -> Void, onRemoveItem: @escaping (CartItem) -> Void, onTapDiscountDecreaseBtn: @escaping (Discount) -> Void, onTapDiscountIncreaseBtn: @escaping (Discount) -> Void, onRemoveDiscount: @escaping (Discount) -> Void) {
        self.cartItems = cartItems
        self.discounts = Dictionary(grouping: discounts, by: { $0.id })
        self.onTapDecreaseBtn = onTapDecreaseBtn
        self.onTapIncreaseBtn = onTapIncreaseBtn
        self.onRemoveItem = onRemoveItem
        self.onTapDiscountDecreaseBtn = onTapDiscountDecreaseBtn
        self.onTapDiscountIncreaseBtn = onTapDiscountIncreaseBtn
        self.onRemoveDiscount = onRemoveDiscount
    }
    
    public func getProductName(cartItem: CartItem) -> String {
        if(cartItem.coffeeHowToBrew != nil) {
            return "\(cartItem.productName) (\(cartItem.coffeeHowToBrew!.name)"
        }
        return cartItem.productName
    }
    public func getDiscountsPrice(discounts: [Discount]) -> Int64 {
        return Int64(discounts.reduce(0) { $0 + $1.discountPrice }) * -1
    }
    
    var body: some View {
        let discountKeys: [String] = discounts.map{$0.key}
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
                            totalPrice: Int64(cartItem.totalPrice),
                            onRemove: { onRemoveItem(cartItem) },
                            onDecrese: {onTapDecreaseBtn(index)},
                            onIncrease: {onTapIncreaseBtn(index)}
                        )
                    }
                    ForEach(discountKeys, id: \.self) { discountKey in
                        OrderItemView(
                            name: discounts[discountKey]![0].name,
                            quantity: UInt32(discounts[discountKey]!.count),
                            totalPrice: getDiscountsPrice(discounts: discounts[discountKey]!),
                            onRemove: { onRemoveDiscount(discounts[discountKey]![0]) },
                            onDecrese: { onTapDiscountDecreaseBtn(discounts[discountKey]![0]) },
                            onIncrease: { onTapDiscountIncreaseBtn(discounts[discountKey]![0]) }
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
