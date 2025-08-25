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
    }
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
                        Button(action: {}, label: {Text("Add Student")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
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

#Preview {
    AddStudent()
}
