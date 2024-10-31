//
//  Student_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct Student_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    
    // Enum for tracking the stages
    enum Stage {
        case email
        case password
        case name
        case grade
        case state
        case school
        case bus
    }
    
    // Track current stage
    @State private var currentStage: Stage = .email
    
    // Shared variables across views
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var grade: Int = 0
    @State private var school: String = ""
    @State private var bus: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                if currentStage == .email {
                    AdminEmail(email: $email)
                } else if currentStage == .password {
                    AdminPassword(password: $password)
                }
                
                
                // Navigation Buttons
                HStack {
                    // Back button
                    if currentStage == .password {
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
                        Button(action: { currentStage = .password }) {
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
struct StudentEmail: View {
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
struct StudentPassword: View {
    @Binding var password: String
    var body: some View {
        VStack {
            Text("Please enter password here")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            
            TextField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
        }
        .padding()
    }
}

// Name stage view
struct StudentName: View {
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

// Grade stage View
struct StudentGrade {
    @Binding var grade: Int
    var body: some View{
        Text("Hello World")
    }
}

// State stage View
struct StudentState {
    @Binding var state: String
    var body: some View{
        Text("Hello World")
    }
}

// School stage View
struct StudentSchool {
    @Binding var School: String
    var body: some View{
        Text("Hello World")
    }
}

// Bus stage View
struct StudentBus {
    @Binding var bus: String
    var body: some View{
        Text("Hello World")
    }
}

#Preview {
    Student_SignUp()
}
