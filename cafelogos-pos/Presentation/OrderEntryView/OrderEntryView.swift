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
        GeometryReader{geometry in
            
            NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "注文入力") {
                VStack(spacing: 0){
                    HStack(spacing:0){
                        ProductStack()
                            .padding(.leading, 10)
                            .frame(width: geometry.size.width * 0.6)
                        Divider()
                        DiscountStack()
                            .frame(width: geometry.size.width * 0.1)
                        Divider()
                        OrderEntryStack()
                            .frame(width: geometry.size.width * 0.3)
                    }
                    EntryBottomBar()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink{
                            HomeView(isTraining: false)
                        } label:{
                            Text("ホームへ戻る")
                        }
                    }
                }
            }
        }
    }
}

// 商品表示するView
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
                                     GridItem(.flexible(), alignment: .top)], spacing: 10
                        ) {
                            ForEach(category.products, id: \.productId) { product in
                                // ProductCell
                                Button(action: {
                                    
                                }, label: {
                                VStack(alignment: .trailing, spacing: 0) {
                                    // ProductName
                                    Text(product.productName)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.leading)
                                        .padding(.vertical, 5)
                                        .lineLimit(3)
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
                                .frame(maxWidth: (geometry.size.width - 48) / 4) // 列数に合わせて調整
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.brown))
                                )
                                .foregroundColor(.white)
                            })
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// 割引を表示するView
struct DiscountStack: View {
    let discounts: [Discount] = DiscountRepositoryMock().findAll()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                // DiscountCell
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(discounts, id: \.id) { discount in
                        Button(action: {
                            
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
                        .foregroundColor(Color.primary)
                        .frame(minHeight: 120)
                        .frame(maxWidth: (geometry.size.width) - 12)
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

// ここから注文リストのボタン
// 消去ボタン
struct removeButton: View {
    var body: some View {
        Button(action: {
            
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
    }
}
// プラスボタン
struct increaseButton: View {
    var body: some View {
        Button(action: {
            
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
    }
}
// マイナスボタン
struct decreaseButton: View {
    var body: some View {
        Button(action: {

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
    }
}

// 注文リストのView
struct OrderEntryStack: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                Text("注文リスト")
                    .font(.system(.title, weight: .semibold))
                    .padding(.vertical, 10)
                Divider()
                List {
                    ForEach(0..<5) { _ in
                        VStack(spacing: 0){
                            HStack(){
                                Text("品目")
                                    .lineLimit(0)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Spacer()
                                removeButton()
                            }
                            .padding(.bottom, 20)
                            HStack(spacing: 0){
                                decreaseButton()
                                Text("1")
                                    .padding(.horizontal, 10)
                                    .lineLimit(0)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                increaseButton()
                                Spacer()
                                Text("¥500")
                                    .lineLimit(0)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                        }
                    }
                    
                }
                .listStyle(.grouped)
            }
            .frame(maxWidth: geometry.size.width)
        }
    }
}

// 下部バーのボタン
private struct BottomBarButton: View {
    public var text: String
    public var action: () -> Void
    public var bgColor: Color
    public var fgColor: Color
    
    public init(text: String, action: @escaping () -> Void, bgColor: Color, fgColor: Color) {
        self.text = text
        self.action = action
        self.bgColor = bgColor
        self.fgColor = fgColor
    }
    
    var body: some View {
        Button(action: self.action){
            Text(self.text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .font(.system(.title2, weight: .semibold))
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(bgColor)
                }
                .lineLimit(0)
                .foregroundColor(fgColor)
        }
    }
}

// 下部バーのView
struct EntryBottomBar: View {
    var body:some View{
        let screenWidth = UIScreen.main.bounds.size.width
        
            HStack(spacing: 0) {
                Text("999点")
                    .font(.title)
                    .foregroundColor(Color(.systemGray6))
                Text("¥5,000")
                    .font(.title)
                    .foregroundColor(Color(.systemGray6))
                    .padding(.leading)
                Spacer()
                BottomBarButton(text: "伝票呼出", action: {
                }, bgColor: Color(.systemBackground), fgColor: Color.primary)
                .frame(width: 150, height: 60)
                
                BottomBarButton(text: "注文全削除", action: {
                }, bgColor: Color.red, fgColor: Color.white)
                .frame(width: 130, height: 60)
                .padding(.leading, 50)
                // 支払いへのNavigationLink
                NavigationLink {
                    PaymentView()
                } label: {
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
            
        
    }
}

#Preview {
    OrderEntryView()
}
