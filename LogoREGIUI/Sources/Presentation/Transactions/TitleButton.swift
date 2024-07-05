// 遷移先が指定されているボタン
// サブタイトルが付けれる

import SwiftUI

struct TitleButton<Destination>: View where Destination : View {
    var title: String
    var bgColor: Color
    var fgColor: Color
    var destination: () -> Destination

    public init(title: String, bgColor: Color, fgColor: Color, destination: @escaping () -> Destination) {
        self.title = title
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .lineLimit(0)
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

#Preview {
    TitleButton(title: "hoge", bgColor: Color.blue, fgColor: Color.white, destination: {HomeView()})
}
