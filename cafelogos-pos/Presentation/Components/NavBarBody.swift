//
//  NavBarBody.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/23.
//

import SwiftUI

struct NavBarBody <Content: View>: View {
    @ObservedObject var viewModel = GeneralSettingViewModel()
    @Binding var displayConnection: Bool
    @Binding var serverConnection: Bool
    let content: Content
    let title: String
    
    init(displayConnection: Binding<Bool>, serverConnection: Binding<Bool>, title: String, @ViewBuilder content: () -> Content) {
        self._displayConnection = displayConnection
        self._serverConnection = serverConnection
        self.title = title
        self.content = content()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

    }
    var body: some View {
        NavigationStack {
            VStack (spacing: 0.0) {
                content
            }
            .background(Color(.secondarySystemBackground))
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 10) {
                            VStack(alignment: .center) {
                                Image(systemName: displayConnection ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(displayConnection ? .green : .red)
                                Text("料金モニター")
                                    .foregroundColor(displayConnection ? .green : .red)
                            }
                            
                            VStack {
                                Image(systemName: serverConnection ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(serverConnection ? .green : .red)
                                Text("サーバー通信")
                                    .foregroundColor(serverConnection ? .green : .red)
                            }
                            Button(action: {
                                viewModel.openCacher()
                            }) {
                                Text("ドロアを開く")
                            }
                            
                        }
                    }
                }
        }
    }
}


struct NavBarBody_Previews: PreviewProvider {
    static var previews: some View {
        @State var displayConnection: Bool = true
        @State var serverConnection: Bool = true
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "ホーム", content: {
            Divider()
            Spacer()
        })
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
