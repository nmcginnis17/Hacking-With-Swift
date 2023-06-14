//
//  ContentView.swift
//  Guess The Flag SwiftUI
//
//  Created by Nicholas McGinnis on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.indigo
                Color.mint
            }
            Text("Hello, World")
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
