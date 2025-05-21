import SwiftUI
import ComposableArchitecture
import LogoREGICore

// 商品表示するView
public struct ProductStackView: View {
    @Bindable var store: StoreOf<ProductStackFeature>

    @ViewBuilder
    func coffeeProductView(product: ProductDto) -> some View {
        if let brewCount = product.coffeeHowToBrews?.count, brewCount >= 2 {
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .fontWeight(.regular)
            }
        } else {
            Text("¥\(product.coffeeHowToBrews?.first?.amount ?? 0)") // warning回避のため、金額未記載の場合は0を返す
                .font(.title2)
                .fontWeight(.regular)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    func nonCoffeeProductView(product: ProductDto) -> some View {
        Text("¥\(product.amount)")
            .font(.title2)
            .fontWeight(.regular)
            .multilineTextAlignment(.trailing)
            .lineLimit(1)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(store.productCatalog, id: \.id) { category in
                        
                        // カテゴリ内に少なくとも1つのisNowSalesがtrueの商品がある場合のみ表示
                        if category.products.contains(where: { $0.isNowSales }) {
                            // CategoryName
                            Text(category.name)
                                .font(.system(.title, weight: .semibold))
                                .foregroundStyle(.primary)
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
                                        store.send(.onTapProduct(product))
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
                                            VStack {
                                                if product.productType == .coffee {
                                                    coffeeProductView(product: product)
                                                } else {
                                                    nonCoffeeProductView(product: product)
                                                }
                                            }
                                        }
                                        .padding(10)
                                        .frame(minHeight: 120)
                                        .frame(maxWidth: abs((geometry.size.width - 48) / 4))
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.brown))
                                        )
                                        .foregroundStyle(.white)
                                    })
                                }
                            }
                        }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            store.send(.fetch)
        }
        .sheet(item: $store.scope(state: \.destination?.chooseCoffeeBrew, action: \.destination.chooseCoffeeBrew)) { store in
            ChooseCoffeeBrewSheetView(store: store)
        }
    }
}
