//
//  Driver_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import Foundation
import FirebaseAuth


struct Driver_SignUp: View {
    
    // Defining Driver struct for JSON function
    struct Driver: Codable {
        var accountID: Int
        var schoolID: Int
        var busID: Int
        
        enum CodingKeys: String, CodingKey {
            case accountID = "account_id"
            case schoolID = "school_id"
            case busID = "bus_id"
        }
        
        init(accountID: Int, schoolID: Int, busID: Int) {
            self.accountID = accountID
            self.schoolID = schoolID
            self.busID = busID
        }
        
    }
    
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
    
    class Account: Codable, ObservableObject {
        var firstName: String
        var lastName: String
        var email: String
        var accountType: String
        var schoolID: Int
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case email
            case accountType = "account_type"
            case schoolID = "school_id"
        }
        
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
    @State private var bus: Int = 0
    @EnvironmentObject var newAccount: NewAccount
    @EnvironmentObject var obtainAccountInfo: ObtainAccountInfo
    
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
                .onAppear() {
                    Task {
                        try await newAccount.addAccount(NewAccount.Account(firstName: firstname, lastName: lastname, email: email, accountType: "driver", schoolID: schoolID))
                        try await obtainAccountInfo.obtainAccountInfo(email: email)
                        if let accountID = obtainAccountInfo.account.first?.id{
                            try await addDriver(Driver(accountID: accountID, schoolID: schoolID, busID: bus))
                        }
                        if let account = obtainAccountInfo.account.first{
                            let defaults = UserDefaults.standard
                            defaults.set(account.firstName, forKey: "firstName")
                            defaults.set(account.lastName, forKey: "lastName")
                            defaults.set(account.schoolID, forKey: "schoolID")
                            defaults.set(account.email, forKey: "email")
                            defaults.set(account.accountType, forKey: "accountType")
                            defaults.set(account.id, forKey: "accountID")
                            defaults.set(true, forKey: "WasUserLoggedIn")
                        }
                    }
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
    
    func addDriver(_ driver: Driver) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/driver/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(driver)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
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
    @Binding var bus: Int
    @Binding var schoolID: Int
    @EnvironmentObject var getBuses: GetBuses
    @State var loading: Bool = true
    
    var body: some View {
        VStack {
            if loading {
                ProgressView("Loading available buses...")
                    .multilineTextAlignment(.center)
                    .colorScheme(.light)
            } else {
                if getBuses.buses.isEmpty {
                    Text("No buses available for this school yet, please check back later.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                } else {
                    Text("What bus do you drive?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                    
                    Picker("Select a bus", selection: $bus) {
                        ForEach(getBuses.buses, id: \.id) { bus in
                            Text("\(bus.busCode)").tag(bus.id)
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
                    try await getBuses.fetchBuses(schoolID: schoolID)
                } catch {
                    print("Failed to fetch schools: \(error)")
                }
                loading = false
                
            }
        }
    }

}

struct DriverVerification: View {
    @Binding var isVerified: Bool
    @State private var pollingTimer: Timer? = nil
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var email: String
    @Binding var schoolID: Int
    
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
        }
    }
    
    //Function created by ChatGPT
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
