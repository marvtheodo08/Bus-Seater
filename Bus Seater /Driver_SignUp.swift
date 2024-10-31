//
//  Driver_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct Driver_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    
    // Enum for tracking the stages
    enum Stage {
        case email
        case password
        case name
        case state
        case school
        case bus
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
    @State private var bus: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                if currentStage == .email {
                    DriverEmail(email: $email)
                } else if currentStage == .password {
                    DriverPassword(password: $password)
                }
                else if currentStage == .name {
                    DriverName(firstname: $firstname, lastname: $lastname)
                }
                else if currentStage == .state {
                    DriverState(state: $state)
                }
                else if currentStage == .school {
                    DriverSchool(school: $school)
                }
                else if currentStage == .bus {
                    DriverBus(bus: $bus)
                }
                
                
                // Navigation Buttons
                HStack {
                    // Back button
                    if currentStage == .name {
                        Button(action: { currentStage = .email }) {
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
                    
                    // Next button
                    if currentStage == .email {
                        Button(action: { currentStage = .name }) {
                            Image(systemName: "arrow.right")
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
struct DriverEmail: View {
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
struct DriverPassword{
    @Binding var password: String
    var body: some View{
        Text("Hello World")
    }
}


// Name stage view
struct DriverName: View {
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
struct DriverState {
    @Binding var state: String
    var body: some View{
        Text("Hello World")
    }
}

// School stage View
struct DriverSchool {
    @Binding var School: String
    var body: some View{
        Text("Hello World")
    }
}

// Bus stage View
struct DriverBus {
    @Binding var bus: String
    var body: some View{
        Text("Hello World")
    }
}


#Preview {
    Driver_SignUp()
}
