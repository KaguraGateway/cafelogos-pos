//
//  SwiftUIView 2.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI

// マイナスボタン
struct DecreaseButton: View {
    let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.tertiaryLabel))
                    .frame(width: 40, height: 40)
                    .clipped()
                Image(systemName: "minus")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
