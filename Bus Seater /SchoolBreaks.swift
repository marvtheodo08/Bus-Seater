//
//  SchoolBreaks.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/26/25.
//

import SwiftUI

struct SchoolBreak: Codable {
    let schoolId: Int
    let breakType: String
    let startDate: Date
    let endDate: Date
    
    init(schoolId: Int, breakType: String, startDate: Date, endDate: Date) {
        self.schoolId = schoolId
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
    @State private var breakType: String = "Christmas"
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
                    BreakStartDate(startDate: $startDate)
                case .endDate:
                    BreakEndDate(endDate: $endDate)
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
                        Button(action: {currentStage = .addingBreak}, label: {Text("Create Break")
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
            Text("What type of break are you setting?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker("Break Type", selection: $breakType) {
                Text("Christmas").tag("Christmas")
                Text("Winter (Febuary)").tag("Winter (Febuary)")
                Text("Spring").tag("Spring")
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct BreakStartDate: View {
    @Binding var startDate: Date
    
    var body: some View {
        VStack {
            Text("When is the first day of the break?")
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

struct BreakEndDate: View {
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("When is the last day of the break?")
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

struct AddingBreak: View {
    @Binding var breakAdded: Bool
    @Binding var breakType: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            ProgressView("Adding break to database...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            Task {
                try await addBreak(SchoolBreak(schoolId: UserDefaults.standard.integer(forKey: "schoolID"), breakType: breakType, startDate: startDate, endDate: endDate))
            }
            breakAdded = true
        }
    }
    func addBreak(_ schoolBreak: SchoolBreak) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/break/create/") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(identifier: "America/New_York")
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(formatter)
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(schoolBreak)
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
