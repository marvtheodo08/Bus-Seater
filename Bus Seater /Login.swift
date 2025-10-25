//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI
import FirebaseAuth

//Enum suggested by ChatGPT
enum AccountType: String, Identifiable {
    case admin
    case driver
    case student

    var id: String { self.rawValue }
}

struct Login: View {
    @State var email: String = ""
    @State var password: String  = ""
    @State var userSigningUp = false
    @State var userLoggingIn = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
            ZStack {
                if userLoggingIn {
                    LoggingUserIn(email: $email, userLoggingIn: $userLoggingIn)
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
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                            .accentColor(.black)
                        Button(action: {login(email: email, password: password)}, label: {Text("Log in")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal, 100)
                                .background(Color.blue
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                                .padding()
                        })
                        Button(action: {appState.path.append(.signup)}, label: {Text("Don't have an account? Sign up here!")})
                    }
                    .padding()
                    
                }
            }
            
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .wrongPassword:
                    print("Wrong Password")
                case .invalidEmail:
                    print("Invalid Email")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            }
            else {
                print ("User logging in")
                userLoggingIn = true
            }
        }
    }
}

struct LoggingUserIn: View {
    @Binding var email: String
    @Binding var userLoggingIn: Bool
    @State private var accountType: String = ""
    @State private var type: AccountType? = nil
    @EnvironmentObject var obtainAccountInfo: ObtainAccountInfo
    
    var body: some View {
        VStack {
            if userLoggingIn {
                ProgressView("Logging you in...")
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear{
            Task {
                let account = try await obtainAccountInfo.obtainAccountInfo(email: email)
                do {
                  let account = try await obtainAccountInfo.obtainAccountInfo(email: email)
                    let defaults = UserDefaults.standard
                    defaults.set(account.firstName, forKey: "firstName")
                    defaults.set(account.lastName, forKey: "lastName")
                    defaults.set(account.schoolID, forKey: "schoolID")
                    defaults.set(account.email, forKey: "email")
                    defaults.set(account.accountType, forKey: "accountType")
                    defaults.set(account.id, forKey: "accountID")
                    defaults.set(true, forKey: "WasUserLoggedIn")
                    accountType = account.accountType
                }
                catch {
                    print("Failed to fetch obtain account info: \(error)")
                }
                if accountType == "admin" {
                    type = .admin
                }
                else if accountType == "driver" {
                    type = .driver
                }
                else {
                    type = .student
                }
            }
            
        }
        .onDisappear {
            userLoggingIn = false
        }
        .fullScreenCover(item: $type) { type in
            switch type {
            case .admin:
                AdminHomepage()
            case .driver:
                DriverHomepage()
            case .student:
                StudentHomepage()
            }
        }
        
    }
}

#Preview {
    Login()
}
