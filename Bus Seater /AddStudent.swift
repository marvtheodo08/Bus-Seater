//
//  AddStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/25/25.
//

import SwiftUI

enum Stage {
    case name
    case grade
    case addingStudent
}

struct AddStudent: View {
    @Environment(\.dismiss) var dismiss
    @State private var studentAdded: Bool = false
    @State private var currentStage: Stage = .name
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var grade: String = ""
    var bus: Bus?
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
                    AddingStudent(firstname: $firstname, lastname: $lastname, grade: $grade, bus: bus)
                }
                if currentStage != .addingStudent{
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
            }
            .padding(.bottom, 250)
            
            Button(action: {dismiss()}, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })
            .padding(.bottom, 700)
            .padding(.leading, 310)
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
    @Environment(\.dismiss) var dismiss
    @State private var accountID: Int = 0
    @State private var busID: Int = 0
    @State private var schoolID: Int = 0
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var grade: String
    @EnvironmentObject var getUserToken: GetUserToken
    @EnvironmentObject var studentAdded: StudentAdded
    var bus: Bus?
    
    var body: some View {
        NavigationStack{
            if !studentAdded.studentAdded {
                VStack {
                    ProgressView("Adding student to database...")
                        .multilineTextAlignment(.center)
                        .colorScheme(.light)
                }
            }
            else{
                ViewStudents(bus: bus)
            }
        }
        .onAppear {
            schoolID = UserDefaults.standard.integer(forKey: "schoolID")
            Task {
                try await addStudent(NewStudent(
                    busId: bus?.id ?? 0,
                    schoolId: schoolID,
                    grade: grade,
                    firstName: firstname,
                    lastName: lastname
                ))
            }
            studentAdded.studentAdded = true
            dismiss()
        }
    }
    func addStudent(_ student: NewStudent) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/student/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        let token = try await getUserToken.getUserToken()
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(student)
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
