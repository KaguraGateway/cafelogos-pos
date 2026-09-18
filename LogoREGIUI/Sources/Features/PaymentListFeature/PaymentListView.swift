
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
                                HStack(alignment: .firstTextBaseline, spacing: 12) {
                                    Text("オーダー番号")
                                        .font(.system(.body, weight: .medium))
                                    Text(formatCallNumbers(payment.callNumbers))
                                        .font(.system(.title, weight: .bold))
                                    if payment.isCanceled {
                                        CanceledBadge()
                                    }
                                    Spacer()
                                    cancelButton(payment)
                                }

                                HStack {
                                    Text("日時:\(formatDate(payment.paymentAt))")
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

                                if let canceledAt = payment.canceledAt {
                                    HStack {
                                        Text("取消日時: \(formatDate(canceledAt))")
                                            .font(.system(.body, weight: .medium))
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .foregroundStyle(payment.isCanceled ? Color.secondary : Color.primary)
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
        .alert($store.scope(state: \.alert, action: \.alert))
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder
    private func cancelButton(_ payment: Payment) -> some View {
        if payment.isCanceled {
            EmptyView()
        } else if store.cancelingPaymentId == payment.id {
            ProgressView()
                .frame(width: 88, height: 32)
        } else {
            HStack(spacing: 8) {
                // 外部決済はSquare端末で返金する必要があるため、POSからは取消できない
                if payment.type != .cash {
                    Text("Square端末で返金してください")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(Color.secondary)
                }
                Button("取消") {
                    store.send(.cancelButtonTapped(payment))
                }
                .font(.system(.body, weight: .bold))
                .frame(width: 88, height: 32)
                .foregroundStyle(payment.type == .cash ? Color.red : Color.secondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(payment.type == .cash ? Color.red : Color.secondary, lineWidth: 1)
                )
                .buttonStyle(.plain)
                .disabled(payment.type != .cash || store.cancelingPaymentId != nil)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }

    private func formatCallNumbers(_ callNumbers: [String]) -> String {
        return callNumbers.isEmpty ? "-" : callNumbers.joined(separator: ", ")
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

private struct CanceledBadge: View {
    var body: some View {
        Text("取消済")
            .font(.system(.caption, weight: .bold))
            .foregroundStyle(Color.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary)
            )
    }
}

#Preview {
    PaymentListView(
        store: .init(initialState: .init()) {
            PaymentListFeature()
        }
    )
}
