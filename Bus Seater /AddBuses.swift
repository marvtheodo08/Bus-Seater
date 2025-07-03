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
        case seats
        case rows
        case row_seats
    }
    
    @State private var busCode: String = ""
    @State private var seats: Int = 0
    @State private var rows: Int = 0
    @State private var currentStage: Stage = .bus_code
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                // Display the current stage view
                switch currentStage {
                case .bus_code:
                    BusCode(busCode: $busCode)
                case .seats:
                    BusSeats(seats: $seats)
                case .rows:
                    BusRows(rows: $rows)
                case .row_seats:
                    RowSeats()
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
                        Button(action: {}, label: {Text("Add Bus")
                                .foregroundStyle(.black)
                        })
                    }
                }
                .padding(.horizontal)
            }

            
        }
    }
    func goBack() {
        switch currentStage {
        case .seats: currentStage = .bus_code
        case .rows: currentStage = .seats
        default: break
        }
    }
    
    func goNext() {
        switch currentStage {
        case .bus_code: currentStage = .seats
        case .seats: currentStage = .rows
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

// Seats stage view
struct BusSeats: View {
    @Binding var seats: Int
    
    var body: some View {
        VStack {
            Text("How many seats does this bus have?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Seats", value: $seats, format: .number)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
                .keyboardType(.numberPad)
        }
        .padding()
    }
}

// Bus rows stage view
struct BusRows: View {
    @Binding var rows: Int
    
    var body: some View {
        VStack {
            Text("How many seats does this bus have?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
            
            TextField("Seats", value: $rows, format: .number)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(3))
                .accentColor(.black)
                .colorScheme(.light)
                .keyboardType(.numberPad)
        }
        .padding()
    }
}

struct RowSeats: View {
    var body: some View {
        VStack {
            Text("Add how many seats per row.")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundStyle(.black)
                .padding(.bottom, 50)
        }
        .padding()
    }
}

#Preview {
    AddBuses()
}
