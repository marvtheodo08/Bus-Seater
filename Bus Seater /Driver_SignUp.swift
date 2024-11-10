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

struct DriverSchools: Identifiable, Codable {
    let id: Int
    let schoolName: String
    let municipality: String
    let state: String
    let stateAbriviation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case schoolName = "school_name"
        case municipality
        case state
        case stateAbriviation = "state_abriviation"
    }
    
}

struct Driver_SignUp: View {
    @State private var schools: [DriverSchools] = []
    private var cancellables = Set<AnyCancellable>()
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
                    DriverSchool(school: $school, state: $state, schools: $schools)
                }
                else if currentStage == .bus {
                    DriverBus(bus: $bus)
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
        case .state: currentStage = .name
        case .school: currentStage = .state
        case .bus: currentStage = .school
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
                    }
                }
            }
        }
    }
}
    func fetchSchools(state: String) async {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/\(state)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([DriverSchools].self, from: data) {
                schools = decodedResponse
            }
        }
        catch {
            print("Error fetching schools: \(error.localizedDescription)")
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

// Password stage view
struct DriverPassword: View {
    @Binding var password: String
    
    var body: some View {
        VStack {
            Text("What is your desired password?")
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
struct DriverName: View {
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
struct DriverSchool: View {
    @Binding var school: String
    @Binding var state: String
    @Binding var schools: [DriverSchools]
    
    var body: some View{
        VStack {
            Text("What school do you attend?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
            Picker("School", selection: $school) {
                ForEach(schools, id: \.id) { school in
                    Text(school.schoolName).tag(school.schoolName)
                }
            }
            .colorScheme(.light)
        }
        .onAppear {
            Task{
                await  fetchSchools()
            }
            
            
        }
    }
    func fetchSchools() async {
        await Admin_SignUp().fetchSchools(state: state)
    }
}

    
    // Bus stage View
    struct DriverBus: View {
        @Binding var bus: String
        
        var body: some View{
            Text("What is your bus number/code?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, 50)
        }
    }
    
    
    
#Preview {
    Driver_SignUp()
}
