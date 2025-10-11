import SwiftUI
import LogoREGICore

struct OrderListView: View {
    public let orders: [Order]
    
    public init(orders: [Order]) {
        self.orders = orders;
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("注文リスト")
                .font(.system(.title, weight: .semibold))
                .padding(.vertical, 10)
            Divider()
            List {
                ForEach(orders.indexed(), id: \.index) { (_, order) in
                    ForEach(order.cart.items.indexed(), id: \.index) { (index, item) in
                        HStack{
                            VStack(alignment: .leading, spacing:0){
                                Text(item.coffeeHowToBrew != nil ? "\(item.productName) (\(item.coffeeHowToBrew!.name))" : item.productName)
                                    .font(.system(.title2 , weight: .semibold))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text("\(item.getQuantity())"+"点")
                                    .padding(.top, 16)
                                    .font(.title2)
                            }
                            Spacer()
                            Text("¥\(item.totalPrice)")
                                .lineLimit(0)
                                .font(.system(.title2 , weight: .semibold))
                        }
                        .padding(.vertical, 10)
                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .listStyle(PlainListStyle())
            VStack(spacing: 0) {
                Text("割引リスト")
                    .font(.system(.title, weight: .semibold))
                    .padding(.vertical, 10)
                Divider()
                List {
                    ForEach(orders.indexed(), id: \.index) { (_, order) in
                        ForEach(order.discounts.indexed(), id: \.index) { (index, item) in
                            HStack{
                                VStack(alignment: .leading, spacing:0){
                                    Text(item.name)
                                        .font(.system(.title2 , weight: .semibold))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                }
                                Spacer()
                                Text("¥-\(item.discountPrice)")
                                    .lineLimit(0)
                                    .font(.system(.title2 , weight: .semibold))
                            }
                            .padding(.vertical, 10)
                            
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(PlainListStyle())
            }
        }
    }
}

#Preview {
    OrderListView(orders: [])
}
