//
//  OrderEntryView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/06.
//

import SwiftUI

struct OrderEntryView: View {
    
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "注文入力") {
            VStack(spacing: 0){
                HStack(spacing:0){
                    ProductStack()
                        .padding(.leading)
                        .frame(width: screenWidth * 0.6)
                    Divider()
                    DiscountStack()
                        
                    Divider()
                    OrderEntryStack()
                }
            EntryBottomBar()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            
        }
    }
}

struct ProductStack: View {
    let productCategories: [ProductCategoryDto] = ProductQueryServiceMock().fetchProducts() // データを取得
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(productCategories, id: \.id) { category in
                        // CategoryName
                        Text(category.name)
                            .font(.system(.title, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.top)
                            
                        
                        // ProductsGrid
                        LazyVGrid(columns:
                                    [GridItem(.flexible(), alignment: .top),
                                     GridItem(.flexible(), alignment: .top),
                                     GridItem(.flexible(), alignment: .top),
                                     GridItem(.flexible(), alignment: .top)], spacing: 16) {
                            ForEach(category.products, id: \.productId) { product in
                                // ProductCell
                                VStack(alignment: .trailing, spacing: 0) {
                                    // ProductName
                                    Text(product.productName)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 5)
                                        .lineLimit(2)
                                        .frame(maxWidth: .infinity)

                                    Spacer()
                                    
                                    // ProductAmount
                                    Text("¥\(product.amount)")
                                        .font(.title2)
                                        .fontWeight(.regular)
                                        .multilineTextAlignment(.trailing)
                                        .lineLimit(1)
                                }
                                .padding(10)
                                .frame(minHeight: 120)
                                .frame(maxWidth: (geometry.size.width - 40) / 4) // 列数に合わせて調整
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.brown))
                                )
                                .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}


struct DiscountStack: View {
    var body:some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(0..<2) { _ in // Replace with your data model here
                    VStack(spacing: 0) {
                        Text("割引")
                            .font(.system(.title2, weight: .bold))
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
                            .clipped()
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                        Text("-¥500")
                            .font(.system(.title2, weight: .regular))
                            .padding(.bottom, 10)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 15)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.secondary))
                    }
                    .frame(width: 100, height: 100)
                    .clipped()
                    .foregroundColor(Color(.systemBackground))
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            .frame(width: 120)
            .clipped()
        }
    }
}

struct OrderEntryStack: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("注文リスト")
                .font(.system(.title, weight: .semibold))
                .padding(.vertical, 10)
            Divider()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<5) { _ in // Replace with your data model here
                        VStack(spacing: 0) {
                            HStack {
                                Text("品目")
                                    .lineLimit(0)
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.red)
                                        .frame(width: 40, height: 40)
                                        .clipped()
                                    Image(systemName: "trash")
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(Color(.systemGray6))
                                }
                            }
                            .padding(.bottom, 20)
                            HStack(spacing: 0) {
                                HStack {
                                    
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color(.tertiaryLabel))
                                        .frame(width: 40, height: 40)
                                        .clipped()
                                    Image(systemName: "minus")
                                        .imageScale(.large)
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(.white)
                                }
                                Text("1")
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 10)
                                    .lineLimit(0)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color(.tertiaryLabel))
                                        .frame(width: 40, height: 40)
                                        .clipped()
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text("¥500")
                                    .lineLimit(0)
                            }
                        }
                        .padding(20)
                        .background {
                            VStack {
                                Divider()
                                Spacer()
                                Divider()
                            }
                        }
                        .background(Color(.systemBackground))
                        .font(.system(.title2, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
        }
    }
}

struct EntryBottomBar: View {
    var body:some View{
        HStack(spacing: 0) {
            Text("999点")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
            Text("¥5,000")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Spacer()
            HStack(spacing: 0) {
                ForEach(0..<2) { _ in // Replace with your data model here
                    Text("項目")
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .padding(.vertical)
                        .font(.system(.title2, weight: .semibold))
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(.secondarySystemGroupedBackground))
                        }
                        .lineLimit(0)
                        .foregroundColor(.primary)
                }
                .frame(width: 150)
                .clipped()
                .padding(.horizontal, 10)
            }
            Text("支払いへ進む")
                .frame(width: 200)
                .clipped()
                .padding(.vertical)
                .font(.system(.title2, weight: .bold))
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.blue)
                }
                .lineLimit(0)
                .foregroundColor(.white)
                .padding(.leading, 70)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 15)
        .background {
            VStack {
                Divider()
                Spacer()
            }
        }
        .background(.primary)
    }
}

#Preview {
    OrderEntryView()
}
