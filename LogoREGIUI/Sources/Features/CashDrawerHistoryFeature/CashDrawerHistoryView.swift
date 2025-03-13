// レジ操作履歴画面

import SwiftUI
import ComposableArchitecture
import LogoREGICore

struct CashDrawerHistoryView: View {
    @Bindable var store: StoreOf<CashDrawerHistoryFeature>
    
    var body: some View {
        ContainerWithNavBar {
            VStack(spacing: 0) {
                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Form {
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
                                        Text("\(denomination.operationType.rawValue)")
                                            .font(.system(.title3, weight: .bold))
                                            .foregroundColor(getOperationTypeColor(denomination.operationType))
                                        Text("更新: \(formatDate(denomination.updatedAt))")
                                            .font(.body)
                                        Text("作成: \(formatDate(denomination.createdAt))")
                                            .font(.body)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listStyle(PlainListStyle())
                        .padding(.horizontal ,150)
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
    
    private func getOperationTypeColor(_ operationType: DenominationOperationType) -> Color {
        switch operationType {
        case .cashDrawerOpening:
            return Color.blue
        case .settlement:
            return Color.green
        case .unknown:
            return Color.gray
        }
    }
}

#Preview {
    CashDrawerHistoryView(
        store: .init(initialState: .init()) {
            CashDrawerHistoryFeature()
        }
    )
}
