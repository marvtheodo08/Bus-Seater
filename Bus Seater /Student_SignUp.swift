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
        case name
    }
    
    // Track current stage
    @State private var currentStage: Stage = .email
    
    // Shared variables across views
    @State private var email: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                if currentStage == .email {
                    StudentEmail(email: $email)
                } else if currentStage == .name {
                    StudentName(firstname: $firstname, lastname: $lastname)
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

#Preview {
    Student_SignUp()
}
