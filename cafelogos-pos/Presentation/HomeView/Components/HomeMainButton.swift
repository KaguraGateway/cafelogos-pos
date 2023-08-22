//
//  HomeMainButton.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/23.
//

import SwiftUI

struct HomeMainButton<Content: View>: View {
    var title: String
    var subtitle: String
    var description: String
    var destination: Content
    
    var body: some View {
        NavigationLink(destination: destination) {
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
            .foregroundColor(.primary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .aspectRatio(1/1, contentMode: .fit)
            .clipped()
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.systemFill))
            }
        }
    }
}


struct HomeMainButton_Previews: PreviewProvider {
    static var previews: some View {
        @State var serverConnection: Bool = true
        @State var displayConnection: Bool = true
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム", content: {
            Divider()
            HomeMainButton(title: "Title", subtitle: "Subtitle", description: "Description", destination:
                            OrderInputView()
            )
            
            
        })
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
