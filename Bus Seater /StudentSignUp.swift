//
//  Student_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import Foundation
import FirebaseAuth

struct StudentSignUp: View {
    
    // Enum suggested by ChatGPT
    // Enum for tracking the stages
    enum Stage {
        case email
        case password
        case name
        case grade
        case state
        case municipality
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
    
    @EnvironmentObject var getSchools: GetSchools
    
    // Track current stage
    @State private var currentStage: Stage = .email
    
    // Shared variables across views
    @State private var isEmailVerified: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var grade: String = ""
    @State private var state: String = ""
    @State private var municipality: String = ""
    @State private var schoolID: Int = 0
    @State private var busID: Int = 0
    @EnvironmentObject var newAccount: NewAccount
    @EnvironmentObject var obtainAccountInfo: ObtainAccountInfo
    @AppStorage("WasUserLoggedIn") private var WasUserLoggedIn = false
    @AppStorage("accountType") private var accountType = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .email:
                    StudentEmail(email: $email)
                case .password:
                    StudentPassword(password: $password)
                case .name:
                    StudentAccountName(firstname: $firstname, lastname: $lastname)
                case .grade:
                    StudentAccountGrade(grade: $grade)
                case .state:
                    StudentState(state: $state)
                case .municipality:
                    StudentMunicipality(municipality: $municipality)
                case .school:
                    StudentSchool(schoolID: $schoolID, state: $state, municipality: $municipality)
                case .bus:
                    StudentBus(busID: $busID, schoolID: $schoolID)
                case .verification:
                    StudentVerification(isEmailVerified: $isEmailVerified, firstname: $firstname, lastname: $lastname, grade: $grade, schoolID: $schoolID, busID: $busID, email: $email, password: $password)
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
                    if currentStage != .verification {
                        if currentStage == .bus {
                            Button(action: { goNext() }, label: {Text("Create Account")
                                    .foregroundStyle(.black)
                            })
                        }
                        else {
                            Button(action: { goNext() }) {
                                Image(systemName: "arrow.right")
                                    .padding()
                                    .foregroundStyle(.blue)
                            }
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
        }
        .onChange(of: isEmailVerified){ oldValue, newValue in
            if newValue {
                Task {
                    try await newAccount.addAccount(NewAccount.Account(firstName: firstname, lastName: lastname, email: email, accountType: "student", schoolId: schoolID))
                    do {
                      let account = try await obtainAccountInfo.obtainAccountInfo(email: email)
                        let defaults = UserDefaults.standard
                        defaults.set(account.firstName, forKey: "firstName")
                        defaults.set(account.lastName, forKey: "lastName")
                        defaults.set(account.schoolId, forKey: "schoolID")
                        defaults.set(account.email, forKey: "email")
                        defaults.set(account.id, forKey: "accountID")
                        accountType = account.accountType
                        WasUserLoggedIn = true
                    }
                    catch {
                        print("Failed to fetch account info: \(error)")
                    }
                }
            }
        }

    }
    
    func goBack() {
        switch currentStage {
        case .password: currentStage = .email
        case .name: currentStage = .password
        case .grade: currentStage = .name
        case .state: currentStage = .grade
        case .municipality: currentStage = .state
        case .school: currentStage = .municipality
        case .bus: currentStage = .school
        case .verification: currentStage = .bus
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .email: currentStage = .password
        case .password: currentStage = .name
        case .name: currentStage = .grade
        case .grade: currentStage = .state
        case .state: currentStage = .municipality
        case .municipality: currentStage = .school
        case .school: currentStage = .bus
        case .bus: currentStage = .verification
        default: break
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
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
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
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
        }
        .padding()
    }
}

// Name stage view
struct StudentAccountName: View {
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
            
            TextField("Last name", text: $lastname)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
        }
        .padding()
    }
}

// Grade stage View
struct StudentAccountGrade: View {
    @Binding var grade: String
    
    var body: some View{
        Text("What grade level are you in?")
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundStyle(.black)
            .padding(.bottom, 50)
        Picker(
            selection: $grade,
            label: Text("Grade"),
            content: {
                ForEach(6..<13) { grade in
                    Text("\(grade)")
                        .tag("\(grade)")
                }
            }
            
        )
        .pickerStyle(WheelPickerStyle())
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
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker("State", selection: $state) {
                ForEach(states, id: \.self) { stateOption in
                    Text(stateOption).tag(stateOption)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct StudentMunicipality: View {
    @Binding var municipality: String
    
    var body: some View {
        VStack {
            Text("Please enter the town or city your school is in.")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Town or City", text: $municipality)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
        }
        .padding()
    }
}


// School stage View
struct StudentSchool: View {
    @Binding var schoolID: Int
    @Binding var state: String
    @Binding var municipality: String
    @EnvironmentObject var getSchools: GetSchools
    @State var loading: Bool = true
    @State private var schools = [School]()
    
    var body: some View {
        VStack {
            if loading {
                ProgressView("Loading available schools...")
                    .multilineTextAlignment(.center)
            } else {
                if schools.isEmpty {
                    Text("No schools available for \(state) yet, please check back later.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                } else {
                    Text("What school do you attend?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                    
                    Picker("Select a School", selection: $schoolID) {
                        ForEach(schools, id: \.id) { school in
                            Text("\(school.schoolName), \(school.municipality)").tag(school.id)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    loading = true
                    schools = try await getSchools.fetchSchools(state: state, municipality: municipality)
                } catch {
                    print("Failed to fetch schools: \(error)")
                }
                loading = false
            }
        }
    }
}

// Bus stage View
struct StudentBus: View {
    @Binding var busID: Int
    @Binding var schoolID: Int
    @EnvironmentObject var getBuses: GetBuses
    @State var loading: Bool = true
    @State private var buses = [Bus]()
    
    var body: some View {
        VStack {
            if loading {
                ProgressView("Loading available buses...")
                    .multilineTextAlignment(.center)
            } else {
                if buses.isEmpty {
                    Text("No buses available for this school yet, please check back later.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                } else {
                    Text("What bus are you on?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                    
                    Picker("Select a bus", selection: $busID) {
                        ForEach(buses, id: \.id) { bus in
                            Text("\(bus.busCode)").tag(bus.id)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    loading = true
                    buses = try await getBuses.fetchBuses(schoolID: schoolID)
                } catch {
                    print("Failed to fetch schools: \(error)")
                }
                loading = false
                
            }
        }
    }

}

struct StudentVerification: View {
    @Binding var isEmailVerified: Bool
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var grade: String
    @Binding var schoolID: Int
    @Binding var busID: Int
    @Binding var email: String
    @Binding var password: String
    @State private var student: Student? = nil
    @State private var infoTrue: Bool = false
    @State private var studentChecked: Bool = false
    @State private var pollingTimer: Timer? = nil
    
    var body: some View {
        if !studentChecked {
            VStack {
                ProgressView("Give us a moment while we verify this info...")
                    .multilineTextAlignment(.center)
            }
            .onAppear {
                Task {
                    do {
                        let result = try await verifyStudent(firstname: firstname, lastname: lastname, grade: grade, schoolID: schoolID, busID: busID)
                        student = result
                        infoTrue = true
                        emailVerification(email: email, password: password, firstname: firstname)
                    } catch {
                        student = nil
                        infoTrue = false
                    }
                    studentChecked = true
                }
            }
        }
        else {
            if infoTrue {
                VStack {
                    ProgressView("We've sent you an email for verification. Once verified, reopen the app and you will be redirected to the homepage. (Check spam folder if needed)")
                        .multilineTextAlignment(.center)
                }
                .onAppear {
                    if !isEmailVerified{
                        startPolling()
                    }
                }
            }
            else {
                VStack {
                    Text("Looks like the info you provided is false. Please sign up for a different bus.")
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    // Function created by ChatGPT
    func startPolling() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            guard let user = Auth.auth().currentUser else { return }
            user.reload { error in
                if let error = error {
                    print("Error reloading user: \(error)")
                } else if user.isEmailVerified {
                    isEmailVerified = true
                    stopPolling()
                }
            }
        }
    }
    
    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    func verifyStudent(firstname: String, lastname: String, grade: String, schoolID: Int, busID: Int) async throws -> Student {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/student/verify/\(firstname)/\(lastname)/\(grade)/\(schoolID)/\(busID)") else {
            throw URLError(.badURL)
        }
                
        let (data, response) = try await URLSession.shared.data(from: url)
        print("Request URL: \(url)")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        print("Response body: \(String(data: data, encoding: .utf8) ?? "No body")")
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let fetchedStudent = try JSONDecoder().decode(Student.self, from: data)
        
        return fetchedStudent
    }
    
    func emailVerification(email: String, password: String, firstname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error)")
                return
            }
            
            guard let user = authResult?.user else { return }
            
            // Update display name
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = firstname
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating profile: \(error)")
                } else {
                    // Send verification email after updating display name
                    user.sendEmailVerification { error in
                        if let error = error {
                            print("Error sending email verification: \(error)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StudentSignUp()
}
