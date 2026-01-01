//
//  AssignStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/30/25.
//

import SwiftUI

struct SeatSelection: View {
    var student: Student? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var obtainBusInfo: ObtainBusInfo
    @EnvironmentObject var getSeats: GetSeats
    @EnvironmentObject var obtainbusIDfromAccount: ObtainBusIDfromAccount
    @State private var busInfo: Bus? = nil
    @State private var busID: Int = 0
    @State private var accountType: String = ""
    @State var loadingSeats = true
    @State private var rowNum: Int = 0
    @State private var seatNum: Int = 0
    @State private var seats = [Seat]()
    @State private var selectionConfirm = false
    @State private var selectedSeat: Seat? = nil

    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let secondColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack{
            if loadingSeats {
                VStack {
                    ProgressView("Loading seats...")
                        .multilineTextAlignment(.center)
                }
            }
            else {
                ZStack{
                    VStack(alignment: .leading) {
                        ScrollView{
                            Text("Legend")
                                .bold()
                                .font(.system(size: 30))
                            if accountType == "driver"{
                              Text("C: Current seat of selected student")
                            }
                            else{
                                Text("C: Your current seat")
                            }
                            Text("X: Unavailable Seat")
                            LazyVGrid(columns: columns, spacing: 16) {
                                // Seat formatting suggested by ChatGPT
                                ForEach(1...rowNum, id: \.self) { row in
                                    if row < rowNum{
                                        ForEach(seats.filter { $0.rowNum == row && $0.seatNumber <= 2 }) { seat in
                                            SeatChoices(selectionConfirm: $selectionConfirm, selectedSeat: $selectedSeat, accountType: $accountType, student: student!, seat: seat)
                                        }
                                        
                                        Color.clear
                                            .frame(width: 15, height: 15)
                                        
                                        ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 2 }) { seat in
                                            SeatChoices(selectionConfirm: $selectionConfirm, selectedSeat: $selectedSeat, accountType: $accountType, student: student!, seat: seat)
                                        }
                                    }
                                    else {
                                        ForEach(seats.filter { $0.rowNum == row && $0.seatNumber == 1 }) { seat in
                                            SeatChoices(selectionConfirm: $selectionConfirm, selectedSeat: $selectedSeat, accountType: $accountType, student: student!, seat: seat)
                                        }
                                        
                                        Color.clear
                                            .frame(width: 15, height: 15)
                                        Color.clear
                                            .frame(width: 15, height: 15)
                                        
                                        ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 1 }) { seat in
                                            SeatChoices(selectionConfirm: $selectionConfirm, selectedSeat: $selectedSeat, accountType: $accountType, student: student!, seat: seat)
                                        }
                                    }
                                }
                                
                            }
                            .padding()
                        }
                        .padding(.top, 50)
                        
                    }
                    Button(action: {dismiss()}, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    })
                    .padding(.bottom, 700)
                    .padding(.leading, 310)
                }
            }
        }
        .onAppear {
            Task {
                busID = try await obtainbusIDfromAccount.obtainBusIDfromAccountID(accountType: UserDefaults.standard.string(forKey: "accountType")!, accountID: UserDefaults.standard.integer(forKey: "accountID"))
                busInfo = try await obtainBusInfo.obtainBusInfo(id: busID)
                rowNum = busInfo?.rowAmount ?? 0
                do {
                    seats = try await getSeats.fetchSeats(busID: busID)
                } catch {
                    print("Failed to fetch seats: \(error)")
                }
                accountType = UserDefaults.standard.string(forKey: "accountType")!
                loadingSeats = false
            }
        }
    }
}

struct SeatChoices: View {
    @Binding var selectionConfirm: Bool
    @Binding var selectedSeat: Seat?
    @Binding var accountType: String
    var student: Student
    @EnvironmentObject var getUserToken: GetUserToken
    @EnvironmentObject var seatChange: SeatChange
    @Environment(\.dismiss) var dismiss
    @State private var oldSeat: Seat? = nil
    let seat: Seat
    
    var alertMessage: String {
        switch accountType {
        case "driver":
            return "Would you like to assign \(student.firstName) \(student.lastName) to row \(selectedSeat?.rowNum ?? 0), seat \(selectedSeat?.seatNumber ?? 0)?"
        default:
            return "Are you sure you would like to choose row \(selectedSeat?.rowNum ?? 0), seat \(selectedSeat?.seatNumber ?? 0) as your seat?"
        }
    }
    
    var body: some View {
        Group {
            if seat.isOccupied {
                if seat.studentId == student.id {
                    VStack{
                        Text("C")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).frame(width: 65.0, height: 65.0))
                }
                else {
                    VStack{
                        Text("X")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).frame(width: 65.0, height: 65.0))
                }
            }
            else {
                Button(action: {selectedSeat = seat; selectionConfirm = true; print("\(seat)"); print("\(student.id)")}, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: 65.0, height: 65.0)
                })
                .alert(alertMessage, isPresented: $selectionConfirm) {
                    Button("Yes", role: .destructive) {
                        dismiss()
                        Task {
                            do {
                                oldSeat = try await getSeatFromStudent(studentID: student.id)
                                if oldSeat != nil{
                                    try await unassignStudent(studentID: student.id)
                                }
                                try await assignStudent(seat: selectedSeat!, studentID: student.id)

                            } catch {
                                print("Error assigning student: \(error)")
                            }
                            seatChange.seatChange = true
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }

            }
        }
    }
    
    func assignStudent(seat: Seat, studentID: Int) async throws {
        
        guard let url = URL(string: "https://bus-seater-api.onrender.com/updateSeatTrue?studentID=\(studentID)") else {
            throw URLError(.badURL)
        }
        
        let token = try await getUserToken.getUserToken()

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(seat)
        } catch {
            print("Failed to encode parameters: \(error)")
        }

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
        
        print("\(seat)")
    }
    
    func unassignStudent(studentID: Int) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/updateSeatFalse?studentID=\(studentID)") else {
            throw URLError(.badURL)
        }
        
        let token = try await getUserToken.getUserToken()

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }

    }
    
    func getSeatFromStudent(studentID: Int) async throws -> Seat? {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/getSeatFromStudent?studentID=\(studentID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Seat?.self, from: data)
        }
    }
    
}


#Preview {
    SeatSelection()
}
