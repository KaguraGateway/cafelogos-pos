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
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    if let iconName = icon {
                        Image(systemName: iconName)
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(fgColor)
                    }
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(.largeTitle, weight: .semibold))
                            .foregroundStyle(fgColor)
                            .lineLimit(0)
                        Text(subTitle)
                            .font(.title3)
                            .foregroundStyle(fgColor)
                            .lineLimit(2)
                    }
                }
                Text(description)
                    .font(.body)
                    .foregroundStyle(Color(.darkGray))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.top)
            }
            .frame(maxWidth: width, maxHeight: height)
            .clipped()
            .padding(.horizontal, 0)
            .padding(.vertical, 0)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
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
        width: 200,
        height: 150,
        icon: "house.fill",
        state: {}
    )
}
