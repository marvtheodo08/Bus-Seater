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
    }
    @State private var busCode: String = ""
    @State private var seats: Int = 0
    @State private var rows: Int = 0
    @State private var currentStage: Stage = .bus_code
    @EnvironmentObject var newBus: NewBus
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

#Preview {
    AddBuses()
}
