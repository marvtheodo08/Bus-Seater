//
//  Student_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import Foundation
import Combine
import FirebaseAuth

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
    @EnvironmentObject var getSchools: GetSchools
    
    // Track current stage
    @State private var currentStage: Stage = .email
    
    // Shared variables across views
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var grade: Int = 0
    @State private var state: String = ""
    @State private var school: String = ""
    @State private var bus: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .email:
                    StudentEmail(email: $email)
                case .password:
                    StudentPassword(password: $password)
                case .name:
                    StudentName(firstname: $firstname, lastname: $lastname)
                case .grade:
                    StudentGrade(grade: $grade)
                case .state:
                    StudentState(state: $state)
                case .school:
                    StudentSchool(school: $school, state: $state)
                case .bus:
                    StudentBus(bus: $bus, school: $school)
                }
                
                
                // Navigation Buttons
                HStack {
                    if currentStage != .email {
                        Button(action: { goBack() }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                    if currentStage != .bus {
                        Button(action: { goNext() }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
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

    func goBack() {
        switch currentStage {
        case .password: currentStage = .email
        case .name: currentStage = .password
        case .grade: currentStage = .name
        case .state: currentStage = .grade
        case .school: currentStage = .state
        case .bus: currentStage = .school
        default: break
        }
    }

    func goNext() {
        switch currentStage {
        case .email: currentStage = .password
        case .password: currentStage = .name
        case .name: currentStage = .grade
        case .grade: currentStage = .state
        case .state: currentStage = .school
        case .school: currentStage = .bus
        default: break
        }
    }
func emailVerification(email: String, password: String, firstname: String) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if let error = error {
            print("Error signing up:", error)
            return
        }
        
        guard let user = authResult?.user else { return }

        // Update display name
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = firstname
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating display name:", error)
            } else {
                // Send verification email after updating display name
                user.sendEmailVerification { error in
                    if let error = error {
                        print("Error sending verification email:", error)
                    } else {
                        print("Verification email sent with display name:", firstname)
                    }
                }
            }
        }
    }
}

}

// Email stage view
struct StudentEmail: View {
    @Binding var email: String
    
    var body: some View {
        VStack {
            Text("What is your personal email address?")
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
            Text("What is you desired password?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            
            SecureField("Password", text: $password)
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
            Text("What is your name?")
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
struct StudentGrade: View {
    @Binding var grade: Int
    
    var body: some View{
        Text("What grade level are you in?")
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundColor(.black)
            .padding(.bottom, 50)
        Picker(
            selection: $grade,
            label: Text("Grade"),
            content: {
                ForEach(6..<13) { grade in
                    Text("\(grade)")
                        .tag(grade)
                }
            }
            
        )
        .pickerStyle(WheelPickerStyle())
        .colorScheme(.light)
    }
}

// State stage View
struct StudentState: View {
    @Binding var state: String 
    
    let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
        "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
        "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
        "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina",
        "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
        "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
        "Wisconsin", "Wyoming"
    ]
    
    var body: some View {
        VStack {
            Text("What state do you live in?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            
            Picker("State", selection: $state) {
                ForEach(states, id: \.self) { stateOption in
                    Text(stateOption).tag(stateOption)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .colorScheme(.light)
        }
    }
}

// School stage View
struct StudentSchool: View {
    @Binding var school: String
    @Binding var state: String
    @EnvironmentObject var getSchools: GetSchools

    var body: some View {
        VStack {
            if getSchools.isLoading {
                ProgressView()
                    .colorScheme(.light)
            } else {
                if getSchools.schools.isEmpty {
                    Text("No schools available, please select a different state.")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                } else {
                    Text("What school do you attend?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                    
                    Picker("Select a School", selection: $school) {
                        ForEach(getSchools.schools, id: \.id) { school in
                            Text(school.schoolName).tag(school.schoolName)
                        }
                    }
                    .colorScheme(.light)                }
            }
        }
        .onAppear {
            Task {
                await getSchools.fetchSchools(state: state)
            }
        }
    }
}
    
    // Bus stage View
    struct StudentBus: View {
        @Binding var bus: String
        @Binding var school: String
        
        var body: some View{
            Text("What is you bus number/code?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            Picker("Bus", selection: $bus) {
            }
            .colorScheme(.light)
        }
    }
    
    #Preview {
        Student_SignUp()
    }
