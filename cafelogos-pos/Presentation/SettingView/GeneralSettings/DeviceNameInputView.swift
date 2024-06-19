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
    
    @Binding var clientName: String
    
    var body: some View {
            VStack(){
                Form {
                    Section {
                        
                        HStack(alignment: .center){
                            
                            TextField("Your iPad", text: $clientName)
                        
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 120)
                .background(Color(.secondarySystemBackground))
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                
                
            }
    }
}
