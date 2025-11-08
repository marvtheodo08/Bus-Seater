//
//  AddSemester.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/7/25.
//

import SwiftUI

struct Semester: Codable {
    let schoolID: Int
    let semesterNumber: Int
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case schoolID = "school_id"
        case semesterNumber = "semester_number"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(schoolID: Int, semesterNumber: Int, startDate: Date, endDate: Date) {
        self.schoolID = schoolID
        self.semesterNumber = semesterNumber
        self.startDate = startDate
        self.endDate = endDate
    }
    
}

struct AddSemester: View {
    
    enum Stage {
        case semesterNumber
        case startDate
        case endDate
        case addingQuarter
    }
    
    @State private var quarterAdded = false
    @State private var semesterNumber: Int = 1
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var currentStage: Stage = .semesterNumber
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .semesterNumber:
                    SemesterNumber(semesterNumber: $semesterNumber)
                case .startDate:
                    SemesterStartDate(startDate: $startDate)
                case .endDate:
                    SemesterEndDate(endDate: $endDate)
                case .addingQuarter:
                    AddingSemester(quarterAdded: $quarterAdded, semesterNumber: $semesterNumber, startDate: $startDate, endDate: $endDate)
                }
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .semesterNumber {
                        Button(action: { goBack() }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    Spacer()
                    if currentStage != .endDate {
                        Button(action: { goNext() }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    else if currentStage == .endDate {
                        Button(action: {currentStage = .addingQuarter}, label: {Text("Create Break")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
        }
        .fullScreenCover(isPresented: $quarterAdded) {
            AdminHomepage()
        }
    }
    
    func goBack() {
        switch currentStage {
        case .endDate: currentStage = .startDate
        case .startDate: currentStage = .semesterNumber
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .semesterNumber: currentStage = .startDate
        case .startDate: currentStage = .endDate
        default: break
        }
    }
}

struct SemesterNumber: View {
    @Binding var semesterNumber: Int
    
    var body: some View {
        VStack {
            Text("What is the semester number?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker(
                selection: $semesterNumber,
                label: Text("Grade"),
                content: {
                    ForEach(1..<3) { quarter in
                        Text("\(quarter)")
                            .tag(quarter)
                    }
                }
                
            )
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct SemesterStartDate: View {
    @Binding var startDate: Date
    
    var body: some View {
        VStack {
            Text("When is the first day of the semester?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            DatePicker(
                "Select a date",
                selection: $startDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}

struct SemesterEndDate: View {
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("When is the last day of the semester?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            DatePicker(
                "Select a date",
                selection: $endDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}

struct AddingSemester: View {
    @Binding var quarterAdded: Bool
    @Binding var semesterNumber: Int
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            ProgressView("Adding semester to database...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            Task {
                try await addSemester(Semester(schoolID: UserDefaults.standard.integer(forKey: "schoolID"), semesterNumber: semesterNumber, startDate: startDate, endDate: endDate))
            }
            quarterAdded = true
        }
    }
    func addSemester(_ semester: Semester) async throws {
        guard let url = URL(string: "\(baseURL)/semester/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                return formatter
            }())
            request.httpBody = try encoder.encode(semester)
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
    AddSemester()
}
