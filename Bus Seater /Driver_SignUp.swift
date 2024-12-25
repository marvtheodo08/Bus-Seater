//
//  Driver_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import Foundation
import Combine
import FirebaseAuth


struct Driver_SignUp: View {
    
    // Enum suggested by ChatGPT
    // Enum for tracking the stages
    enum Stage {
        case email
        case password
        case name
        case state
        case school
        case bus
        case verification
    }
    
    // Track current stage
    @State private var currentStage: Stage = .email
    
    // Shared variables across views
    @State private var isVerified: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var state: String = ""
    @State private var schoolID: Int = 0
    @State private var bus: String = ""
    
    var body: some View {
        ZStack() {
            Color(.white)
                .ignoresSafeArea()
            
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
                    DriverSchool(schoolID: $schoolID, state: $state)
                }
                else if currentStage == .bus {
                    DriverBus(bus: $bus, schoolID: $schoolID)
                }
                else if currentStage == .verification {
                    DriverVerification(isVerified: $isVerified, firstname: $firstname, lastname: $lastname, email: $email, schoolID: $schoolID)
                }
                
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .email {
                        Button(action: { goBack() }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    Spacer()
                    if currentStage != .bus {
                        Button(action: { goNext() }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    else if currentStage == .bus {
                        Button(action: {emailVerification(email: email, password: password, firstname: firstname)}, label: {Text("Create Account")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
        }
        .fullScreenCover(isPresented: $isVerified) {
            DriverHomepage()
        }
    }
    
    func goBack() {
        switch currentStage {
        case .password: currentStage = .email
        case .name: currentStage = .password
        case .state: currentStage = .name
        case .school: currentStage = .state
        case .bus: currentStage = .school
        case .verification: currentStage = .bus
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .email: currentStage = .password
        case .password: currentStage = .name
        case .name: currentStage = .state
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
                            currentStage = .verification
                        }
                    }
                    
                }
            }
        }
    }
    
}

// Email stage view
struct DriverEmail: View {
    @Binding var email: String
    
    var body: some View {
        VStack {
            Text("What is your email address?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
        }
        .padding()
    }
}

// Password stage view
struct DriverPassword: View {
    @Binding var password: String
    
    var body: some View {
        VStack {
            Text("What is your desired password?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
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
struct DriverName: View {
    @Binding var firstname: String
    @Binding var lastname: String
    
    var body: some View {
        VStack {
            Text("What is your name?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
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
struct DriverState: View {
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
                .foregroundStyle(.black)
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
struct DriverSchool: View {
    @Binding var schoolID: Int
    @Binding var state: String
    @EnvironmentObject var getSchools: GetSchools
    @State var loading: Bool = true
    
    var body: some View {
        VStack {
            if loading {
                ProgressView("Loading available schools...")
                    .multilineTextAlignment(.center)
                    .colorScheme(.light)
            } else {
                if getSchools.schools.isEmpty {
                    Text("No schools available for \(state) yet, please check back later.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                } else {
                    Text("What school do you drive for?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                    
                    Picker("Select a School", selection: $schoolID) {
                        ForEach(getSchools.schools, id: \.id) { school in
                            Text("\(school.schoolName), \(school.municipality)").tag(school.id)
                        }
                    }
                    .colorScheme(.light)
                }
            }
        }
        .onAppear {
            Task {
                do {
                    loading = true
                    try await getSchools.fetchSchools(state: state)
                } catch {
                    print("Failed to fetch schools: \(error)")
                }
                loading = false
                
            }
        }
    }
}


// Bus stage View
struct DriverBus: View {
    @Binding var bus: String
    @Binding var schoolID: Int
    
    var body: some View{
        Text("What is your bus number/code?")
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundStyle(.black)
            .padding(.bottom, 50)
        Picker("Bus", selection: $bus) {
        }
        .colorScheme(.light)
        
    }
}

struct DriverVerification: View {
    @Binding var isVerified: Bool
    @State private var pollingTimer: Timer? = nil
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var email: String
    @Binding var schoolID: Int
    @EnvironmentObject var newaccount: NewAccount
    @EnvironmentObject var account: Account
    
    var body: some View {
        VStack {
            ProgressView("We've sent an email for verification. Once verified, reopen the app and you will be redirected to the homepage.")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            if !isVerified{
                startPolling()
            }
            else {
                account.firstName = firstname
                account.lastName = lastname
                account.email = email
                account.accountType = "driver"
                account.schoolID = schoolID
                
                Task {
                    do {
                        _ = try await newaccount.createAccount(newAccount: account)
                    } catch {
                        print("Failed to fetch schools: \(error)")
                    }
                    
                }
            }
        }
    }
    
    func startPolling() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            guard let user = Auth.auth().currentUser else { return }
            user.reload { error in
                if let error = error {
                    print("Error reloading user:", error.localizedDescription)
                } else if user.isEmailVerified {
                    print("User email is verified")
                    isVerified = true
                    stopPolling()
                }
            }
        }
    }
    
    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
}

#Preview {
    Driver_SignUp()
}
