//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    @State var email: String = ""
    @State var password: String  = ""
    @State var UserSigningUp = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Welcome to Bus Seater, the world's first bus seating app!")
                        .multilineTextAlignment(.center)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                    Spacer()
                        .frame(height: 50)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        .accentColor(.black)
                        .colorScheme(.light)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        .accentColor(.black)
                        .colorScheme(.light)
                    Button(action: {}, label: {Text("Log in")
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 100)
                            .background(Color.blue
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        
                            .padding()
                    })
                    Button(action: {UserSigningUp = true}, label: {Text("Don't have an account? Sign up here!")})
                }
                .padding()
                .navigationDestination(isPresented: $UserSigningUp) {
                    SignUp()
                }
                
            }
        }

    }



}

        
#Preview {
    Login()
}
