//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI
import SQLite3

struct Login: View {
    @State var username: String = ""
    @State var password: String  = ""
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Welcome to Bus Seater, the world's first bus seating app!")
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("Username", text: $username)
                TextField("Password", text: $password)
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
