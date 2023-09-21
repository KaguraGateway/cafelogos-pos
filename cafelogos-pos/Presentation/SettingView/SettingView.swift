//
//  SettingView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/21.
//

import SwiftUI

struct SettingView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "設定"){
            List(){
                
                NavigationLink(destination: {
                    GeneralSettingView()                }, label: {
                        Text("一般")
                    })
                Text("カスタマーディスプレイ")
                Text("プリンター")
            }
            
        }
    }
}



struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad (9th generation)")
//            .previewDevice("iPad mini (6th generation)")
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
