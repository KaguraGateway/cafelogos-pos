//
//  ContentView.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/08.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        CashDrawerSetupView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AnyTransition {
    static var rightToLeft: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
}
