// レジ操作履歴画面

import SwiftUI
import ComposableArchitecture
import LogoREGICore

struct CashDrawerHistoryView: View {
    @Bindable var store: StoreOf<CashDrawerHistoryFeature>
    
    var body: some View {
        ContainerWithNavBar {
            VStack(spacing: 0) {
                Text("レジ操作履歴")
                    .font(.system(.title, weight: .semibold))
                    .padding(.vertical, 10)
                Divider()
                
                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(store.denominations.sorted(by: { $0.amount > $1.amount }), id: \.amount) { denomination in
                            HStack {
                                Text("¥\(denomination.amount)")
                                    .font(.system(.title2, weight: .semibold))
                                    .frame(width: 100, alignment: .leading)
                                
                                Text("\(denomination.quantity)枚")
                                    .font(.title2)
                                    .frame(width: 80, alignment: .leading)
                                
                                Text("¥\(denomination.total())")
                                    .font(.system(.title2, weight: .semibold))
                                    .frame(width: 120, alignment: .leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("更新: \(formatDate(denomination.updatedAt))")
                                        .font(.caption)
                                    Text("作成: \(formatDate(denomination.createdAt))")
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationTitle("レジ操作履歴")
        .alert($store.scope(state: \.alert, action: \.alert))
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    CashDrawerHistoryView(
        store: .init(initialState: .init()) {
            CashDrawerHistoryFeature()
        }
    )
}
