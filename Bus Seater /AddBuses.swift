//
//  AddBuses.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 7/3/25.
//

import SwiftUI

struct AddBuses: View {
    enum Stage {
        case bus_code
        case rows
        case addingBus
    }
    @State private var busAdded: Bool = false
    @State private var busCode: String = ""
    @State private var seats: Int = 0
    @State private var rows: Int = 0
    @State private var currentStage: Stage = .bus_code
    @EnvironmentObject var getBuses: GetBuses
    var body: some View {
        ZStack {
            VStack {
                // Display the current stage view
                switch currentStage {
                case .bus_code:
                    BusCode(busCode: $busCode)
                case .rows:
                    BusRows(rows: $rows)
                case .addingBus:
                    AddingBus(busCode: $busCode, seats: $seats, rows: $rows, busAdded: $busAdded)
                }
                
                // Navigation Buttons sugguested by ChatGPT
                HStack {
                    if currentStage != .bus_code {
                        Button(action: { goBack() }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    Spacer()
                    if currentStage != .rows {
                        Button(action: { goNext() }) {
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(.blue)
                        }
                    }
                    else if currentStage == .rows {
                        Button(action: {currentStage = .addingBus}, label: {Text("Add Bus")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }

            
        }
        .fullScreenCover(isPresented: $busAdded) {
            AdminHomepage()
        }
    }
        func goBack() {
            switch currentStage {
            case .rows: currentStage = .bus_code
            default: break
            }
        }
        
        func goNext() {
            switch currentStage {
            case .bus_code: currentStage = .rows
            default: break
            }
        }
}

// Bus code stage view
struct BusCode: View {
    @Binding var busCode: String
    
    var body: some View {
        VStack {
            Text("What is your code for your bus?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Bus Code", text: $busCode)
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

// Bus rows stage view
struct BusRows: View {
    @Binding var rows: Int
    
    var body: some View {
        VStack {
            Text("How many rows does this bus have?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            Picker(
                selection: $rows,
                label: Text("Grade"),
                content: {
                    ForEach(5..<14) { option in
                        Text("\(option)")
                            .tag(option)
                    }
                }
                
            )
            .pickerStyle(WheelPickerStyle())
            .colorScheme(.light)
        }
        .padding()
    }
}

struct AddingBus: View {
    
    struct NewBus: Codable {
        var rowAmount: Int
        var seatCount: Int
        var busCode: String
        var schoolID: Int
        
        enum CodingKeys: String, CodingKey {
            case rowAmount = "row_amount"
            case seatCount = "seat_count"
            case busCode = "bus_code"
            case schoolID = "school_id"
        }
        
        init(rowAmount: Int, seatCount: Int, busCode: String, schoolID: Int) {
            self.rowAmount = rowAmount
            self.seatCount = seatCount
            self.busCode = busCode
            self.schoolID = schoolID
        }
        
    }
    
    struct NewRow: Codable {
        var rowNumber: Int
        var seatCount: Int
        var busID: Int
        
        enum CodingKeys: String, CodingKey {
            case rowNumber = "row_num"
            case seatCount = "seat_count"
            case busID = "bus_id"
        }
        
        init(rowNumber: Int, seatCount: Int, busID: Int) {
            self.rowNumber = rowNumber
            self.seatCount = seatCount
            self.busID = busID
        }
        
    }
    
    struct NewSeat: Codable {
        var busID: Int
        var rowNumber: Int
        var seatNumber: Int
        
        enum CodingKeys: String, CodingKey {
            case busID = "bus_id"
            case rowNumber = "row_num"
            case seatNumber = "seat_number"
        }
        
        init(busID: Int, rowNumber: Int, seatNumber: Int) {
            self.busID = busID
            self.rowNumber = rowNumber
            self.seatNumber = seatNumber
        }
        
    }
    
    @EnvironmentObject var obtainBusID: ObtainBusID
    @State private var busID: Int = 0
    @State private var schoolID: Int = 0
    @Binding var busCode: String
    @Binding var seats: Int
    @Binding var rows: Int
    @Binding var busAdded: Bool
    
    var body: some View {
        VStack {
            ProgressView("Adding bus to database...")
                .multilineTextAlignment(.center)
        }
        .onAppear {
            seats = rows * 4 - 1
            schoolID = UserDefaults.standard.integer(forKey: "schoolID")
            Task {
                try await addBus(NewBus(rowAmount: rows, seatCount: seats, busCode: busCode, schoolID: schoolID))
                try await obtainBusID.obtainBusID(bus_code: busCode, school_id: schoolID)
                busID = obtainBusID.id?.busID ?? 0
                var i = 1
                while i <= rows {
                    if i == rows {
                        try await addRow(NewRow(rowNumber: i, seatCount: 3, busID: busID))
                        var j = 1
                        while j <= 3 {
                            try await addSeat(NewSeat(busID: busID, rowNumber: i, seatNumber: j))
                            j = j + 1
                        }
                    }
                    else {
                        try await addRow(NewRow(rowNumber: i, seatCount: 4, busID: busID))
                        var j = 1
                        while j <= 4 {
                            try await addSeat(NewSeat(busID: busID, rowNumber: i, seatNumber: j))
                            j = j + 1
                        }
                    }
                    i = i + 1
                }
            }
            busAdded = true
        }
    }
    
    func addBus(_ bus: NewBus) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/bus/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(bus)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
    func addRow(_ row: NewRow) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/row/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(row)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
    func addSeat(_ seat: NewSeat) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/seat/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(seat)
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
    AddBuses()
}
