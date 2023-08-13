//
//  ContentView.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

        }
        .padding()
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
