//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI

// 消去ボタン
struct RemoveButton: View {
    public let onAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.onAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.red)
                    .frame(width: 40, height: 40)
                    .clipped()
                Image(systemName: "trash")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color(.systemGray6))
                    .fontWeight(.bold)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
