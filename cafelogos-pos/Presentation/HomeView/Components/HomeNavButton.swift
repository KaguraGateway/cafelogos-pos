//
//  HomeNavButton.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/27.
//

import SwiftUI

struct HomeNavButton<Destination>: View where Destination : View {
    var title: String
    var subtitle: String
    var description: String
    var destination: () -> Destination
    var fg_color: Color
    var bg_color: Color
    var height: Double
    var width: Double

    init(title: String, subtitle: String, description: String, destination: @escaping () -> Destination, fg_color: Color, bg_color: Color, height: Double, width: Double) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.destination = destination
        self.fg_color = fg_color
        self.bg_color = bg_color
        self.height = height
        self.width = width
    }
    
    var body: some View {
        NavigationLink(destination: {
            destination()
        }, label: {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(.largeTitle, weight: .semibold))
                    .lineLimit(0)
                Text(subtitle)
                    .font(.title3)
                    .lineLimit(2)
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.top, 10)
            }
            .foregroundColor(fg_color)
            .frame(maxWidth: width, maxHeight: height)
            .clipped()
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(bg_color)
            }
        })
    }
}

struct HomeNavButton_Previews: PreviewProvider {
    static var previews: some View {
        @State var serverConnection: Bool = true
        @State var displayConnection: Bool = true
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム", content: {
            Divider()
//            HomeNavButton(title: "Title", subtitle: "Subtitle", description: "Description",, destination: {OrderInputView(productQueryService: ProductQueryServiceMock(), discountRepository: DiscountRepositoryMock())})
            GeometryReader {geometry in
                HomeNavButton(title: "Title", subtitle: "SubButton", description: "Description", destination: {SettingView()}, fg_color: Color.primary, bg_color: Color(.systemFill), height: geometry.size.height * (1/3), width: geometry.size.width * 0.3)
            }
            
            Spacer()
            
            
        })
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}

