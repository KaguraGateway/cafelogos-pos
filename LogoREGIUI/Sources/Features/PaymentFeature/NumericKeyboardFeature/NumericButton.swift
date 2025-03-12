import SwiftUI

struct NumericButton: View {
    let numericStr: String
    let onAction: () -> Void

    var body: some View {
        Button(action: {
            onAction()
        }) {
            Text(numericStr)
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(getTextColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(getBackgroundColor())
                        
                        // ⌫ボタンのみdarkGrayのアウトラインを追加
                        if numericStr == "⌫" {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color(.darkGray), lineWidth: 4)
                        }
                    }
                )
        }
    }
    
    private func getBackgroundColor() -> Color {
        if numericStr == "⌫" {
            return Color(.lightGray)
        } else if numericStr.hasPrefix("¥") {
            return Color(.darkGray)
        } else {
            return Color(.systemFill)
        }
    }
    
    private func getTextColor() -> Color {
        if numericStr == "⌫" || numericStr.hasPrefix("¥") {
            return .white
        } else {
            return .primary
        }
    }
}


#Preview {
    NumericButton(numericStr: "1", onAction: {
        print("Press")
    })
}
