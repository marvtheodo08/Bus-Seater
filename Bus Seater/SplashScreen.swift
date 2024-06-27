//
//  SwiftUIView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/22/24.
//

import SwiftUI
import SQLite3

struct SplashScreen: View {
    var body: some View {
            ZStack {
                Color("Backround Color")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Application logo")
                        .foregroundColor(.black)
                }
                .padding()
            }

    }
}

#Preview {
    SplashScreen()
}
