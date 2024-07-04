//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI
import LogoREGICore


// 商品表示するView
struct ProductStack: View {
    
    @State private var showingChooseOption: Bool = false
    @State private var selectProduct: ProductDto? = nil
    var productCategories = [ProductCategoryWithProductsDto]()
    var onAddItem: (ProductDto, CoffeeHowToBrewDto?) -> Void
    
    func onTapProduct(product: ProductDto) {
        if(product.productType == ProductType.coffee){
            if(product.coffeeHowToBrews?.count == 1) {
                self.onAddItem(product, product.coffeeHowToBrews![0])
            } else {
                self.selectProduct = product
                self.showingChooseOption = true
            }
        } else {
            self.onAddItem(product, nil)
        }
    }
    
    func onTapCoffeeBrew(product: ProductDto, option: Option) {
        let brewIndex = product.coffeeHowToBrews!.firstIndex(where: {
            $0.id == option.id
        })
        self.onAddItem(product, product.coffeeHowToBrews![brewIndex!])
    }

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
                                if product.isNowSales {
                                    Button(action: {
                                        onTapProduct(product: product)
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
                                        .frame(maxWidth: abs((geometry.size.width - 48) / 4))
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
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingChooseOption) {
            ChooseOptionSheetView(selectProduct: $selectProduct, onTapCoffeeBrew: onTapCoffeeBrew)
        }
    }
}
