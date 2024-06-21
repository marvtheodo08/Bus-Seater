//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack
        {
          Color("Backround Color")
          .ignoresSafeArea()
            VStack(spacing: 0.0) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, World!")
            }
            .padding()
        }
    
    }
}

#Preview {
    ContentView()
}
