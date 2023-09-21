//
//  DeviceNameInputViiew.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/22.
//

import SwiftUI

struct DeviceNameInputViiew: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    @State private var deviceName = ""
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "端末名"){
            VStack(){
                Form {
                    Section {

                                HStack(alignment: .center){
                                    
                                    TextField("Your iPad", text: $deviceName)
                                        
                                }

                    }
                    
                }
                .background(Color(.secondarySystemBackground))
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                
                
            }
        }
    }
    
    struct DeviceNameInputViiew_Previews: PreviewProvider {
        static var previews: some View {
            DeviceNameInputViiew()
                .previewInterfaceOrientation(.landscapeRight)
    //            .previewDevice("iPad (9th generation)")
    //            .previewDevice("iPad mini (6th generation)")
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}
