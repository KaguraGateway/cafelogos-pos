//
//  StartTransactionView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/23.
//

import SwiftUI

struct StartTransactionView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    
    @State var denominations = Denominations()
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "レジ開け"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    ChargeInputView(denominations: $denominations)
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "釣り銭準備金", amount: Int(denominations.total()))
                            .padding(.bottom)
                            .padding(.top, 50)
                        Spacer()
                        multi2Button(title: "スキップする", subtitle: "(トレーニングモード)", bgColor: Color.secondary, fgColor: Color.white, destination: {HomeView(isTraining: true)})
                        TitleButton(title: "次へ", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView(isTraining: false)})
                            
                            .padding(.bottom)
                       
                        
                        
                        
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
    }
}

struct multi2Button<Destination>: View where Destination : View {
    var title: String
    var subtitle: String?
    var bgColor: Color
    var fgColor: Color
    var destination: () -> Destination
    
    public init(title: String, subtitle: String?, bgColor: Color, fgColor: Color, destination: @escaping () -> Destination) {
        self.title = title
        self.subtitle = subtitle
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(0)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.title)
                }
            }
            .foregroundColor(fgColor)
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
            .clipped()
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(bgColor)
            }
            .padding(.bottom)
        }
    }
}


struct StartTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        StartTransactionView()
            .previewInterfaceOrientation(.landscapeRight)
//            .previewDevice("iPad (9th generation)")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
