//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI
import SQLite3

struct Login: View {
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to Bus Seater, the world's first bus seating app!")
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                    .frame(height: 250)
            }
            .padding()
        }
    }
}

#Preview {
    Login()
}
