import SwiftUI

struct HomeNavigationButton<P>: View {
    let title: String
    let subTitle: String
    let description: String
    
    let fgColor: Color
    let bgColor: Color
    
    let width: Double
    let height: Double
    
    let icon: String?

    let state: P?
    
    var body: some View {
        NavigationLink(state: state) {
            VStack(spacing: 0) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .padding(.bottom, 5)
                }
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
            .foregroundStyle(fgColor)
            .frame(maxWidth: width, maxHeight: height)
            .clipped()
            .padding(.horizontal, 0)
            .padding(.vertical, 0)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(red: 0.44, green: 0.25, blue: 0.25), lineWidth: 4)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(.systemBackground)))
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
        icon: "house.fill",
        state: {}
    )
}
