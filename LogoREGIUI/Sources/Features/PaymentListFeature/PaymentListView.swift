
import SwiftUI
import ComposableArchitecture
import LogoREGICore

struct PaymentListView: View {
    @Bindable var store: StoreOf<PaymentListFeature>
    
    var body: some View {
        ContainerWithNavBar{
            VStack(spacing: 0) {
                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if store.payments.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("決済履歴が存在しません。")
                            .font(.system(.title3, weight: .bold))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(store.payments, id: \.id) { payment in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("日時: \(formatDate(payment.paymentAt))")
                                        .font(.system(.body, weight: .medium))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("支払い方法: \(getPaymentTypeText(payment.type))")
                                        .font(.system(.body, weight: .medium))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("支払額: ¥\(payment.paymentAmount)")
                                        .font(.system(.body, weight: .medium))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("受取額: ¥\(payment.receiveAmount)")
                                        .font(.system(.body, weight: .medium))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("お釣り: ¥\(payment.changeAmount)")
                                        .font(.system(.body, weight: .medium))
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                    .padding(.horizontal ,150)
                }
            }
        }
        .navigationTitle("レジ決済履歴")
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func getPaymentTypeText(_ type: PaymentType) -> String {
        switch type {
        case .cash:
            return "現金"
        case .external:
            return "外部決済"
        }
    }
}

#Preview {
    PaymentListView(
        store: .init(initialState: .init()) {
            PaymentListFeature()
        }
    )
}
