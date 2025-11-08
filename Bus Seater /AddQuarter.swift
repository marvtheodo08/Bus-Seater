//
//  AddQuarter.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/7/25.
//

import SwiftUI

struct SchoolQuarter: Codable {
    let schoolID: Int
    let quarterNumber: Int
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case schoolID = "school_id"
        case quarterNumber = "quarter_number"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(schoolID: Int, quarterNumber: Int, startDate: Date, endDate: Date) {
        self.schoolID = schoolID
        self.quarterNumber = quarterNumber
        self.startDate = startDate
        self.endDate = endDate
    }
    
}


struct AddQuarter: View {
    
    enum Stage {
        case quarterNumber
        case startDate
        case endDate
        case addingQuarter
    }
    
    @State private var quarterAdded = false
    @State private var quarterNumber: Int = 1
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var currentStage: Stage = .quarterNumber
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .quarterNumber:
                    QuarterNumber(quarterNumber: $quarterNumber)
                case .startDate:
                    QuarterStartDate(startDate: $startDate)
                case .endDate:
                    QuarterEndDate(endDate: $endDate)
                case .addingQuarter:
                    AddingQuarter(quarterAdded: $quarterAdded, quarterNumber: $quarterNumber, startDate: $startDate, endDate: $endDate)
                }
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .quarterNumber {
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
        case .startDate: currentStage = .quarterNumber
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .quarterNumber: currentStage = .startDate
        case .startDate: currentStage = .endDate
        default: break
        }
    }
}

struct QuarterNumber: View {
    @Binding var quarterNumber: Int
    
    var body: some View {
        VStack {
            Text("What type of break are you setting?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            Picker(
                selection: $quarterNumber,
                label: Text("Grade"),
                content: {
                    ForEach(1..<5) { quarter in
                        Text("\(quarter)")
                            .tag(quarter)
                    }
                }
                
            )
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct QuarterStartDate: View {
    @Binding var startDate: Date
    
    var body: some View {
        VStack {
            Text("When is the first day of the quarter?")
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

struct QuarterEndDate: View {
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("When is the last day of the quarter?")
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

struct AddingQuarter: View {
    @Binding var quarterAdded: Bool
    @Binding var quarterNumber: Int
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
                try await addQuarter(SchoolQuarter(schoolID: UserDefaults.standard.integer(forKey: "schoolID"), quarterNumber: quarterNumber, startDate: startDate, endDate: endDate))
            }
            quarterAdded = true
        }
    }
    func addQuarter(_ quarter: SchoolQuarter) async throws {
        guard let url = URL(string: "\(baseURL)/quarter/create/") else { fatalError("Invalid URL") }
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
            request.httpBody = try encoder.encode(quarter)
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
    AddQuarter()
}
