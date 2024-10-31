//
//  Admin_SignUp.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/21/24.
//

import SwiftUI

struct Admin_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    
    // Enum for tracking the stages
    enum Stage {
        case email
        case password
        case name
        case state
        case school
    }
    
    // Track current stage
    @State private var currentStage: Stage = .email
    @State private var pastStage: Stage
    
    // Shared variables across views
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var state: String = ""
    @State private var school: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                if currentStage == .email {
                    AdminEmail(email: $email)
                } else if currentStage == .name {
                    AdminName(firstname: $firstname, lastname: $lastname)
                }
                else if currentStage == .state {
                    AdminState(state: $state)
                }
                else if currentStage == .school {
                    AdminSchool(school: $school)
                }
                
                
                // Navigation Buttons
                HStack {
                    // Back button
                    if currentStage != .email || currentStage != .school {
                        Button(action: { }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.blue)
                        }
                        Spacer().frame(width: 306)
                        Button(action: {}) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.blue)
                        }

                    }
                    
                    Spacer()
                    
                    if currentStage == .email {
                        Button(action: { currentStage = .name }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    }

                    if currentStage == .school {
                        Button(action: { currentStage = .state }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    
                    }
                }
            }
            .padding(.bottom, 250)
            
            // Dismiss button (dismisses the entire signup process)
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .font(.title)
                    .padding()
            }
        }
    }
}

// Email stage view
struct AdminEmail: View {
    @Binding var email: String
    
    var body: some View {
        VStack {
            Text("Please enter email")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
        }
        .padding()
    }
}

//Password stage view
struct AdminPassword{
    @Binding var password: String
    var body: some View{
        Text("Hello World")
    }
}

// Name stage view
struct AdminName: View {
    @Binding var firstname: String
    @Binding var lastname: String
    
    var body: some View {
        VStack {
            Text("Please enter first and last name")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            
            TextField("First name", text: $firstname)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
            
            TextField("Last name", text: $lastname)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
        }
        .padding()
    }
}

// State stage View
struct AdminState {
    @Binding var state: String
    var body: some View{
        Text("Hello World")
    }
}

// School stage View
struct AdminSchool {
    @Binding var School: String
    var body: some View{
        Text("Hello World")
    }
}



#Preview {
    Admin_SignUp()
}
