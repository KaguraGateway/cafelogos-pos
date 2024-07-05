// 遷移先が指定されているボタン
// タイトルとサブタイトルが付けれる

import SwiftUI

struct multi2Button<Destination>: View where Destination : View {
    var title: String
    var subtitle: String?
    var bgColor: Color
    var fgColor: Color
    var destination: () -> Destination
    
    public init(title: String, subtitle: String?, bgColor: Color, fgColor: Color, destination: @escaping () -> Destination) {
        self.title = title
        self.subtitle = subtitle
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(0)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.title)
                }
            }
            .foregroundColor(fgColor)
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
            .clipped()
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(bgColor)
            }
            .padding(.bottom)
        }
    }
}

