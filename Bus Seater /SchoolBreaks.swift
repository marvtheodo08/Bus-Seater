//
//  SchoolBreaks.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/26/25.
//

import SwiftUI

struct SchoolBreak: Codable {
    let schoolID: Int
    let breakType: String
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case schoolID = "school_id"
        case breakType = "break_type"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(schoolID: Int, breakType: String, startDate: Date, endDate: Date) {
        self.schoolID = schoolID
        self.breakType = breakType
        self.startDate = startDate
        self.endDate = endDate
    }
    
}

struct SetSchoolBreak: View {
    
    enum Stage {
        case breakType
        case startDate
        case endDate
        case addingBreak
    }
    
    @State private var breakAdded = false
    @State private var breakType: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var currentStage: Stage = .breakType
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .breakType:
                    BreakType(breakType: $breakType)
                case .startDate:
                    StartDate(startDate: $startDate)
                case .endDate:
                    EndDate(endDate: $endDate)
                case .addingBreak:
                    AddingBreak(breakAdded: $breakAdded, breakType: $breakType, startDate: $startDate, endDate: $endDate)
                }
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .breakType {
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
                        Button(action: {}, label: {Text("Create Break")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 250)
        }
        .fullScreenCover(isPresented: $breakAdded) {
            AdminHomepage()
        }
    }
    
    func goBack() {
        switch currentStage {
        case .endDate: currentStage = .startDate
        case .startDate: currentStage = .breakType
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .breakType: currentStage = .startDate
        case .startDate: currentStage = .endDate
        default: break
        }
    }
    
}

struct BreakType: View {
    @Binding var breakType: String
    
    var body: some View {
        VStack {
            Text("What state do you live in?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker("Break Type", selection: $breakType) {
                Text("Christmas").tag("Christmas")
                Text("Winter (Febuary)").tag("Winter (Febuary)")
                Text("Spring").tag("Spring")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

struct StartDate: View {
    @Binding var startDate: Date
    
    var body: some View {
        VStack {
            Text("What state do you live in?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            DatePicker(
                "Select a date",
                selection: $startDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical) // shows a full calendar
            .padding()
        }
    }
}

struct EndDate: View {
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("What state do you live in?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            DatePicker(
                "Select a date",
                selection: $endDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical) // shows a full calendar
            .padding()
        }
    }
}

struct AddingBreak: View {
    @State private var schoolID: Int = 0
    @Binding var breakAdded: Bool
    @Binding var breakType: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            ProgressView("Adding student to database...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            schoolID = UserDefaults.standard.integer(forKey: "schoolID")
            Task {
                try await addBreak(SchoolBreak(schoolID: schoolID, breakType: breakType, startDate: startDate, endDate: endDate))
            }
            breakAdded = true
        }
    }
    func addBreak(_ schoolBreak: SchoolBreak) async throws {
        guard let url = URL(string: "\(baseURL)/student/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(schoolBreak)
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
    SetSchoolBreak()
}
