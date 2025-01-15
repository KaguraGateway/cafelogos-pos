import SwiftUI

struct NumericButton: View {
    let numericStr: String
    let onAction: () -> Void

    var body: some View {
        Button(action: {
            onAction()
        }) {
            Text(numericStr)
                .font(.title)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(.systemFill))
                )
        }
    }
}


#Preview {
    NumericButton(numericStr: "1", onAction: {
        print("Press")
    })
}
