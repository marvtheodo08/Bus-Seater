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
    @State var userSigningUp = false
    @State var userLoggingIn = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                if userLoggingIn {
                    LoggingUserIn()
                }
                else {
                    VStack {
                        Text("Welcome to Bus Seater, the world's first bus seating app!")
                            .multilineTextAlignment(.center)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.black)
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
                        Button(action: {login(email: email, password: password)}, label: {Text("Log in")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal, 100)
                                .background(Color.blue
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                                .padding()
                        })
                        Button(action: {userSigningUp = true}, label: {Text("Don't have an account? Sign up here!")})
                    }
                    .padding()
                    .navigationDestination(isPresented: $userSigningUp) {
                        SignUp()
                    }
                    
                }
                }
            
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in:", error.localizedDescription)
                return
            }
            else {
                print ("User logging in")
                userLoggingIn = true
            }
        }
    }
    
    
}

struct LoggingUserIn: View {
    var body: some View {
        VStack {
            ProgressView("Logging User In...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
    }
}

#Preview {
    Login()
}
