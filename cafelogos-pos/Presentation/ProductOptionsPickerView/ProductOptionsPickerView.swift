//
//  ProductOptionsPickerView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/20.
//

import SwiftUI

struct ProductOptionsPickerView: View {
    let ProductName: String
    let gridItems = [
            GridItem(.flexible(),spacing: 20),
            GridItem(.flexible(),spacing: 20),
            GridItem(.flexible(),spacing: 20),
        ]
    
    var body: some View {
        NavigationStack() {
            LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(0..<12) { index in
                                Button(action: {}){
                                    VStack(spacing: 0) {
                                        Text("オプション")
                                            .font(.system(.largeTitle, weight: .semibold))
                                            .lineLimit(0)
                                        Text("説明")
                                            .padding(.top, 10)
                                            .font(.title3)
                                            .lineLimit(2)

                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
                                    .clipped()
                                    .padding(.vertical, 30)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(Color(.systemFill))
                                    }
                                }
                            }
                        }
                        .padding(20)
            .navigationTitle(ProductName + "のオプションを選択")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
struct ProductOptionsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ProductOptionsPickerView(ProductName: "あつあつ")
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
