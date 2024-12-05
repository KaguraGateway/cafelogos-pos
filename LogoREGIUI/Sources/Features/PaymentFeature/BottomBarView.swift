import SwiftUI
import LogoREGICore

struct BottomBarView: View {
    let totalQuantity: UInt32
    let payment: Payment
    let isPayButtonEnabled: Bool
    
    let onTapPay: () -> Void
    
    public init(totalQuantity: UInt32, payment: Payment,isPayButtonEnabled: Bool, onTapPay: @escaping () -> Void) {
        self.totalQuantity = totalQuantity
        self.payment = payment
        self.isPayButtonEnabled = isPayButtonEnabled
        self.onTapPay = onTapPay
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(totalQuantity)点")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
            Text("¥\(payment.paymentAmount)")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Divider()
                .frame(height: 50)
                .background(Color.white)
                .padding(.horizontal)
            Text("おつり：")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.leading)
            Text("¥\(payment.changeAmount)")
                .font(.title)
                .foregroundColor(Color(.systemGray6))
                .padding(.horizontal)
            Spacer()
            Button(action: {
                onTapPay()
            }){
                Text("¥\(payment.receiveAmount)で会計する")
                    .frame(width: 400)
                    .clipped()
                    .padding(.vertical)
                    .font(.system(.title2, weight: .bold))
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(payment.isEnoughAmount() ? .blue : .gray)
                    }
                    .lineLimit(0)
                    .foregroundColor(.white)
                    .padding(.leading, 70)
            }
            .disabled(!payment.isEnoughAmount() || !isPayButtonEnabled)
            .opacity(!isPayButtonEnabled ? 0.5 : 1)
        }
        .frame(maxWidth: .infinity)
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
}

#Preview {
    BottomBarView(totalQuantity: 10, payment: Payment(type: PaymentType.cash, orderIds: [], paymentAmount: 1000, receiveAmount: 100), isPayButtonEnabled: true, onTapPay: {
        print("tap")
    })
}
