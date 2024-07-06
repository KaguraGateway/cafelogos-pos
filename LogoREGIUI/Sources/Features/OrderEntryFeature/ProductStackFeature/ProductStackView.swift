import SwiftUI
import ComposableArchitecture

// 商品表示するView
public struct ProductStackView: View {
    @Bindable var store: StoreOf<ProductStackFeature>

    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(store.productCatalog, id: \.id) { category in
                        
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
                                            if product.productType == .coffee {
                                                HStack{
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .font(.title2)
                                                        .fontWeight(.regular)
                                                }
                                            } else {
                                                Text("¥\(product.amount)")
                                                    .font(.title2)
                                                    .fontWeight(.regular)
                                                    .multilineTextAlignment(.trailing)
                                                    .lineLimit(1)
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
        .onAppear {
            store.send(.fetch)
        }
        .sheet(item: $store.scope(state: \.destination?.chooseCoffeeBrew, action: \.destination.chooseCoffeeBrew)) { store in
            ChooseCoffeeBrewSheetView(store: store)
        }
    }
}
