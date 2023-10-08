//
//  DeviceNameInputViiew.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/22.
//

import SwiftUI

struct DeviceNameInputView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @ObservedObject var viewModel = DeviceNameInputViewModel()
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "端末名"){
            VStack(){
                Form {
                    Section {
                        
                        HStack(alignment: .center){
                            
                            TextField("Your iPad", text: $viewModel.clientName)
                        
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 120)
                .background(Color(.secondarySystemBackground))
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                
                
            }
        }
    }
}

#Preview {
    DeviceNameInputViiew()
}
