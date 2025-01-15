//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI
import LogoREGICore

// 割引を表示するView
struct DiscountStack: View {
    let discounts: [Discount]
    let onTapDiscount: (Discount) -> Void

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                // DiscountCell
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(discounts, id: \.id) { discount in
                        Button(action: {
                            onTapDiscount(discount)
                        }, label: {
                        VStack(spacing: 0) {
                            // DiscountName
                            Text(discount.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.vertical, 5)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            // DiscountAmount
                            Text("-¥\(discount.discountPrice)")
                                .font(.title2)
                                .fontWeight(.regular)
                                .lineLimit(1)
                        }
                        .padding(10)
                        .foregroundStyle(Color.primary)
                        .frame(minHeight: 120)
                        .frame(maxWidth: abs((geometry.size.width) - 12))
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        }
                        })
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}
