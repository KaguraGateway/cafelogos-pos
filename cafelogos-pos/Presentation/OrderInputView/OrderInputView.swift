//
//  OrderInputView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/14.
//

import SwiftUI
import Algorithms

struct OrderInputView: View {
    @State private var usecase: OrderInputUsecase
    @State private var products: Array<ProductCategoryDto> = []
    @State private var discounts: Array<DiscountDto> = []
    @State private var order: OrderPendingDto

    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    public init(productQueryService: ProductQueryService, discountRepository: DiscountRepository) {
        let usecase = OrderInputUsecase(productQueryService: productQueryService, discountRepository: discountRepository)
        _usecase = State(initialValue: usecase)
        _order = State(initialValue: usecase.getOrder())
    }
    
    var body: some View {
        NavBarBody (displayConnection: $displayConnection, serverConnection: $serverConnection, title: "注文入力") {
            VStack(spacing: 0) {
                Divider()
                HStack(alignment: .top, spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(products.indexed(), id: \.index) { (index, category) in
                                HStack(spacing: 0) {
                                    Text(category.name)
                                        .font(.system(.title, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical)
                                LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)]) {
                                    ForEach(category.products.indexed(), id: \.index) { (index, product) in
                                        Button(action: {
                                            if(product.productType == ProductType.coffee) {
                                                if(product.coffeeHowToBrews!.count > 1) {
                                                    
                                                } else {
                                                    self.usecase.addItemToCart(product: product, productCategory: category, quantity: 1, brew: product.coffeeHowToBrews![0])
                                                }
                                            } else {
                                                self.usecase.addItemToCart(product: product, productCategory: category, quantity: 1)
                                            }
                                        }){
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(product.productName)
                                                    .font(.system(.title2, weight: .bold))
                                                    .padding(.vertical, 5)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    ProductAmount(product: product)
                                                }
                                            }
                                            .padding(10)
                                            .frame(height: 120)
                                            .clipped()
                                            .background {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(.systemBrown)))
                                            }
                                            .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(width: 600)
                        .clipped()
                        .padding(.leading)
                    }
                    Divider()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())]) {
                            ForEach(discounts.indexed(), id: \.index) { (index, discount) in // Replace with your data model here
                                Button(action: {
                                    
                                }){
                                    VStack(spacing: 0) {
                                        Text(discount.name)
                                            .font(.system(.title2, weight: .bold))
                                            .padding(.vertical, 5)
                                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
                                            .clipped()
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.primary)
                                        Text("-¥\(discount.discountPrice)")
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
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .frame(width: 120)
                        .clipped()
                    }
                    Divider()
                    VStack(spacing: 0) {
                        Text("注文リスト")
                            .font(.system(.title, weight: .semibold))
                            .padding(.vertical, 10)
                        Divider()
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(order.cart.items.indexed(), id: \.index) { (index, item) in // Replace with your data model here
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(item.productName)
                                                .lineLimit(0)
                                            Spacer()
                                            Button(action: {
                                                usecase.removeItem(removeItem: item)
                                            }){
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
                                        }
                                        .padding(.bottom, 20)
                                        HStack(spacing: 0) {
                                            HStack {
                                                
                                            }
                                            Button(action: {
                                                usecase.decreaseItemQuantity(itemIndex: index)
                                            }){
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
                                            }
                                            Text("\(item.quantity)")
                                                .foregroundColor(.primary)
                                                .padding(.horizontal, 10)
                                                .lineLimit(0)
                                            Button(action: {
                                                usecase.increaseItemQuantity(itemIndex: index)
                                            }){
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
                                            }
                                            Spacer()
                                            Text("¥\(item.totalAmount)")
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                HStack(spacing: 0) {
                    Text("\(order.cart.totalQuantity)点")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                    Text("¥\(order.totalAmount)")
                        .font(.title)
                        .foregroundColor(Color(.systemGray6))
                        .padding(.leading)
                    Spacer()
                    HStack(spacing: 16) {
                        FooterNormalButton(text: "席番号から", action: {})
                        FooterNormalButton(text: "注文全削除", action: {
                            usecase.removeAllItem()
                        })
                    }
                    .frame(width: 300)
                    .clipped()
                    .padding(.horizontal, 10)
                    NavigationLink {
                        PaymentView()
                    } label: {
                        
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .background(Color(.secondarySystemBackground))
            .onAppear(perform: {
                products = usecase.getProducts()
                discounts = usecase.getDiscounts()
                usecase.subscribeOrder(onPublishOrder: { newOrder in
                    order = newOrder
                })
            })
        }
    }
}

private struct ProductAmount: View {
    let product: ProductDto
    let minAmount: UInt64
    let maxAmount: UInt64
    
    public init(product: ProductDto) {
        self.product = product
        if(product.coffeeHowToBrews != nil && product.coffeeHowToBrews!.count > 0) {
            self.minAmount = product.coffeeHowToBrews!.reduce(product.coffeeHowToBrews![0].price, { x, y in
                min(x, y.price)
            })
            self.maxAmount = product.coffeeHowToBrews!.reduce(0, { x, y in
                max(x, y.price)
            })
        } else {
            self.minAmount = product.amount
            self.maxAmount = product.amount
        }
    }
    
    var body: some View {
        if product.coffeeHowToBrews != nil && product.coffeeHowToBrews!.count > 1 {
            Text("¥\(self.minAmount)~\(self.maxAmount)")
                .font(.system(.title2, weight: .regular))
        } else {
            Text("¥\(self.maxAmount)")
                .font(.system(.title2, weight: .regular))
        }
    }
}

private struct FooterNormalButton: View {
    public var text: String
    public var action: () -> Void
    
    public init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action){
            Text(self.text)
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
    }
}

struct OrderInputView_Previews: PreviewProvider {
    static var previews: some View {
        OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
