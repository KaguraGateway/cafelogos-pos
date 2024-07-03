//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI

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
                RemoveButton(onAction: {
                    onRemove()
                })
                .clipped()
            }
            .padding(.bottom, 20)
            HStack(spacing: 0){
                DecreaseButton(onAction: {
                    onDecrese()
                })
                .clipped()
                Text("\(quantity)")
                    .padding(.horizontal, 10)
                    .lineLimit(0)
                    .font(.title2)
                    .fontWeight(.semibold)
                IncreaseButton(onAction: {
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
