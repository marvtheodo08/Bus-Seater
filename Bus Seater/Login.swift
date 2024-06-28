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
            
            VStack {
                Text("Welcome to Bus Seater, the world's first bus seating app!")
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                    .frame(height: 50)
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                TextField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                Button(action: {}, label: {Text("Don't have an account? Sign up here!")})
            }
            .padding()
        }
    }
}
        
#Preview {
    Login()
}
