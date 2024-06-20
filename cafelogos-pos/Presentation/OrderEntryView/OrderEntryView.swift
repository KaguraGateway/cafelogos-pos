//
//  OrderEntryView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/06.
//

import SwiftUI
import Algorithms
import StarIO10

struct OrderEntryView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @ObservedObject private var viewModel = OrderEntryViewModel()
    
    var body: some View {
        GeometryReader{geometry in
            NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "注文入力") {
                VStack(spacing: 0){
                    HStack(spacing:0){
                        ProductStack(
                            productCategories: viewModel.categoriesWithProduct,
                            onAddItem: viewModel.addItem
                        )
                            .padding(.leading, 10)
                            .frame(width: geometry.size.width * 0.6)
                        Divider()
                        DiscountStack(discounts: viewModel.discounts, onTapDiscount: viewModel.onTapDiscount)
                            .frame(width: geometry.size.width * 0.1)
                        Divider()
                        OrderEntryStack(
                            cartItems: viewModel.order.cart.items,
                            discounts: viewModel.order.discounts,
                            onTapDecreaseBtn: viewModel.onTapDecrease,
                            onTapIncreaseBtn: viewModel.onTapIncrease,
                            onRemoveItem: viewModel.onRemoveItem
                        )
                            .frame(width: geometry.size.width * 0.3)
                    }
                    EntryBottomBar(
                        printer: viewModel.printer, order: viewModel.order, onRemoveAllItem: viewModel.onRemoveAllItem
                    )
                    
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
        .task {
            await self.viewModel.fetch()
        }
    }
}

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
                        .foregroundColor(Color.primary)
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

// ここから注文リストのボタン
// 消去ボタン
struct removeButton: View {
    public let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
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
        .buttonStyle(BorderlessButtonStyle())
    }
}
// プラスボタン
struct increaseButton: View {
    let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
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
        .buttonStyle(BorderlessButtonStyle())
    }
}
// マイナスボタン
struct decreaseButton: View {
    let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
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
        .buttonStyle(BorderlessButtonStyle())
    }
}

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
                removeButton(onAction: {
                    onRemove()
                })
                .clipped()
            }
            .padding(.bottom, 20)
            HStack(spacing: 0){
                decreaseButton(onAction: {
                    onDecrese()
                })
                .clipped()
                Text("\(quantity)")
                    .padding(.horizontal, 10)
                    .lineLimit(0)
                    .font(.title2)
                    .fontWeight(.semibold)
                increaseButton(onAction: {
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
    @State private var showingChooseOrder: Bool = false // 席番号からモーダルの表示bool
    @State private var orderNumber:String = ""
    @State private var orders: [Order] = [Order]()
    @State private var isOrderSheet = false
    public let printer: StarPrinter?
    public let order: Order?
    
    public let onRemoveAllItem: () -> Void
    
    var body:some View{
        let screenWidth = UIScreen.main.bounds.size.width
        
        HStack(spacing: 0) {
            Text("\(order?.cart.totalQuantity ?? 0)点")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
            Text("¥\(order?.totalAmount ?? 0)")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Spacer()
            BottomBarButton(text: "伝票呼出", action: {
                self.showingChooseOrder.toggle()
            }, bgColor: Color(.systemBackground), fgColor: Color.primary)
            .frame(width: 150, height: 60)
            .sheet(isPresented: $showingChooseOrder) {
                ChooseOrderSheet(orders: $orders, isOrderSheet: $isOrderSheet)
            }
            
            BottomBarButton(text: "注文全削除", action: {
                self.onRemoveAllItem()
            }, bgColor: Color.red, fgColor: Color.white)
            .frame(width: 130, height: 60)
            .padding(.leading, 50)
            // 支払いへのNavigationLink
            NavigationLink {
                PaymentView(printer: printer, orders: orders, newOrder: order)
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
        .navigationDestination(isPresented: $isOrderSheet) {
            PaymentView(printer: printer, orders: orders, newOrder: nil)
        }
        .onAppear {
            orders.removeAll()
        }
        
    }
}

#Preview {
    OrderEntryView()
}
