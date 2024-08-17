//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI

struct Login: View {
    @State var username: String = ""
    @State var password: String  = ""
    @State var UserSigningUp = false
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
                Button(action: {}, label: {Text("Log in")
                        .foregroundStyle(Color.white)
                        .padding()
                        .padding(.horizontal, 100)
                        .background(Color.blue
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        
                        .padding()
                        })
                Button(action: {UserSigningUp = true}, label: {Text("Don't have an account? Sign up here!")})
                .sheet(isPresented: $UserSigningUp, content: {SignUp()})
            }
            .padding()
        }

    }



}

        
#Preview {
    Login()
}
