//
//  SwiftUIView.swift
//  
//
//  Created by Owner on 2024/07/04.
//

import SwiftUI

// 下部バーのボタン
struct BottomBarButton: View {
    public let text: String
    public let action: () -> Void
    public let bgColor: Color
    public let fgColor: Color
    
    public init(text: String, action: @escaping () -> Void, bgColor: Color, fgColor: Color) {
        self.text = text
        self.action = action
        self.bgColor = bgColor
        self.fgColor = fgColor
    }
    
    var body: some View {
        Button(action: self.action){
            Text(self.text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .font(.system(.title2, weight: .semibold))
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(bgColor)
                }
                .lineLimit(0)
                .foregroundStyle(fgColor)
        }
    }
}
