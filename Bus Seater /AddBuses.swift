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
            Color(.white)
                .ignoresSafeArea()
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
    @EnvironmentObject var newBus: NewBus
    @EnvironmentObject var newRow: NewRow
    @EnvironmentObject var newSeat: NewSeat
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
                .colorScheme(.light)
        }
        .onAppear {
            seats = rows * 4 - 1
            schoolID = UserDefaults.standard.integer(forKey: "schoolID")
            Task {
                try await newBus.addBus(NewBus.Bus(rowAmount: rows, seatCount: seats, busCode: busCode, schoolID: schoolID))
                try await obtainBusID.obtainBusID(bus_code: busCode, school_id: schoolID)
                busID = obtainBusID.id.first?.id ?? 0
                var i = 1
                while i <= rows {
                    if i == rows {
                        try await newRow.addRow(NewRow.Row(rowNumber: i, seatCount: 3, busID: busID))
                        var j = 1
                        while j <= 3 {
                            try await newSeat.addSeat(NewSeat.Seat(busID: busID, rowNumber: i, seatNumber: j))
                            j = j + 1
                        }
                    }
                    else {
                        try await newRow.addRow(NewRow.Row(rowNumber: i, seatCount: 4, busID: busID))
                        var j = 1
                        while j <= 4 {
                            try await newSeat.addSeat(NewSeat.Seat(busID: busID, rowNumber: i, seatNumber: j))
                            j = j + 1
                        }
                    }
                    i = i + 1
                }
            }
            busAdded = true
        }
    }
}

#Preview {
    AddBuses()
}
