//
//  AddTrimester.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/7/25.
//

import SwiftUI

struct Trimester: Codable {
    let schoolID: Int
    let trimesterNumber: Int
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case schoolID = "school_id"
        case trimesterNumber = "trimester_number"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(schoolID: Int, trimesterNumber: Int, startDate: Date, endDate: Date) {
        self.schoolID = schoolID
        self.trimesterNumber = trimesterNumber
        self.startDate = startDate
        self.endDate = endDate
    }
    
}

struct AddTrimester: View {
    
    enum Stage {
        case trimesterNumber
        case startDate
        case endDate
        case addingQuarter
    }
    
    @State private var quarterAdded = false
    @State private var trimesterNumber: Int = 1
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var currentStage: Stage = .trimesterNumber
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .trimesterNumber:
                    TrimesterNumber(trimesterNumber: $trimesterNumber)
                case .startDate:
                    TrimesterStartDate(startDate: $startDate)
                case .endDate:
                    TrimesterEndDate(endDate: $endDate)
                case .addingQuarter:
                    AddingTrimester(quarterAdded: $quarterAdded, trimesterNumber: $trimesterNumber, startDate: $startDate, endDate: $endDate)
                }
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .trimesterNumber {
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
        case .startDate: currentStage = .trimesterNumber
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .trimesterNumber: currentStage = .startDate
        case .startDate: currentStage = .endDate
        default: break
        }
    }
}

struct TrimesterNumber: View {
    @Binding var trimesterNumber: Int
    
    var body: some View {
        VStack {
            Text("What is the trimester number?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker(
                selection: $trimesterNumber,
                label: Text("Grade"),
                content: {
                    ForEach(1..<4) { quarter in
                        Text("\(quarter)")
                            .tag(quarter)
                    }
                }
                
            )
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct TrimesterStartDate: View {
    @Binding var startDate: Date
    
    var body: some View {
        VStack {
            Text("When is the first day of the trimester?")
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

struct TrimesterEndDate: View {
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("When is the last day of the trimester?")
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

struct AddingTrimester: View {
    @Binding var quarterAdded: Bool
    @Binding var trimesterNumber: Int
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            ProgressView("Adding trimester to database...")
                .multilineTextAlignment(.center)
                .colorScheme(.light)
        }
        .onAppear {
            Task {
                try await addTrimester(Trimester(schoolID: UserDefaults.standard.integer(forKey: "schoolID"), trimesterNumber: trimesterNumber, startDate: startDate, endDate: endDate))
            }
            quarterAdded = true
        }
    }
    func addTrimester(_ trimester: Trimester) async throws {
        guard let url = URL(string: "\(baseURL)/trimester/create/") else { fatalError("Invalid URL") }
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
            request.httpBody = try encoder.encode(trimester)
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
    AddTrimester()
}
