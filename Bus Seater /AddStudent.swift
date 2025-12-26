//
//  AddStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/25/25.
//

import SwiftUI

struct AddStudent: View {
    enum Stage {
        case name
        case grade
        case addingStudent
    }
    @State private var studentAdded: Bool = false
    @State private var currentStage: Stage = .name
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var grade: String = ""
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .name:
                    StudentName(firstname: $firstname, lastname: $lastname)
                case .grade:
                    StudentGrade(grade: $grade)
                case .addingStudent:
                    AddingStudent(firstname: $firstname, lastname: $lastname, grade: $grade, studentAdded: $studentAdded)
                }
                HStack {
                    if currentStage != .name {
                        Button(action: { goBack() }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    Spacer()
                    if currentStage != .grade {
                        Button(action: { goNext() }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    else if currentStage == .grade {
                        Button(action: {currentStage = .addingStudent}, label: {Text("Add Student")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
        }
        .fullScreenCover(isPresented: $studentAdded) {
            DriverHomepage()
        }
    }
    
    func goBack() {
        switch currentStage {
        case .grade: currentStage = .name
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .name: currentStage = .grade
        default: break
        }
    }
}

// Name stage view
struct StudentName: View {
    @Binding var firstname: String
    @Binding var lastname: String
    
    var body: some View {
        VStack {
            Text("What is the student's name?")
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

// Grade stage View
struct StudentGrade: View {
    @Binding var grade: String
    var body: some View{
        Text("What is the grade level of this student?")
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundStyle(.black)
            .padding(.bottom, 50)
        Picker(
            selection: $grade,
            label: Text("Grade"),
            content: {
                Text("K").tag("K")
                ForEach(1..<13) { grade in
                    Text("\(grade)")
                        .tag("\(grade)")
                }
            }
            
        )
        .pickerStyle(WheelPickerStyle())
        .colorScheme(.light)
    }
}

struct AddingStudent: View {
    @State private var accountID: Int = 0
    @State private var accountType: String = ""
    @State private var busID: Int = 0
    @State private var schoolID: Int = 0
    @EnvironmentObject var obtainbusIDfromAccount: ObtainBusIDfromAccount
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var grade: String
    @Binding var studentAdded: Bool
    
    var body: some View {
        VStack {
            ProgressView("Adding student to database...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            schoolID = UserDefaults.standard.integer(forKey: "schoolID")
            accountID = UserDefaults.standard.integer(forKey: "accountID")
            accountType = UserDefaults.standard.string(forKey: "accountType")!
            Task {
                busID = try await obtainbusIDfromAccount.obtainBusIDfromAccountID(accountType: accountType, accountID: accountID)
                try await addStudent(NewStudent(busId: busID, schoolId: schoolID, grade: grade, firstName: firstname, lastName: lastname))
            }
            studentAdded = true
        }
    }
    func addStudent(_ student: NewStudent) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/student/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(student)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
}

#Preview {
    AddStudent()
}
