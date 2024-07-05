import SwiftUI

struct HomeNavigationButton<P>: View {
    let title: String
    let subTitle: String
    let description: String
    
    let fgColor: Color
    let bgColor: Color
    
    let width: Double
    let height: Double

    let state: P?
    
    var body: some View {
        NavigationLink(state: state) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(.largeTitle, weight: .semibold))
                    .lineLimit(0)
                Text(subTitle)
                    .font(.title3)
                    .lineLimit(2)
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.top, 10)
            }
            .foregroundColor(fgColor)
            .frame(maxWidth: width, maxHeight: height)
            .clipped()
            .padding(.horizontal, 0)
            .padding(.vertical, 0)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(bgColor)
            }
        }
    }
}

#Preview {
    HomeNavigationButton(
        title: "ホーム",
        subTitle: "（イートイン管理対応）",
        description: "POSレジ・ハンディ端末から注文を管理",
        fgColor: Color.primary,
        bgColor: Color(.secondarySystemFill),
        width: 100,
        height: 100,
        state: {}
    )
}
