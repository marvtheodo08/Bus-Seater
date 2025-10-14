//
//  AssignStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/30/25.
//

import SwiftUI

struct AssignStudent: View {
    var student: Student? = nil
    @EnvironmentObject var obtainBusInfo: ObtainBusInfo
    @EnvironmentObject var getSeats: GetSeats
    @State private var driverInfo: Driver? = nil
    @State private var busInfo: Bus? = nil
    @State private var busID: Int = 0
    @State var loadingSeats = true
    @State private var rowNum: Int = 0
    @State private var seatNum: Int = 0
    @State private var seats = [Seat]()
    @State private var assignmentConfirm = false
    
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
                        .colorScheme(.light)
                }
            }
            else {
                VStack(alignment: .leading) {
                    ScrollView{
                        Text("Legend")
                            .bold()
                            .font(.system(size: 30))
                        Text("C: Current Seat of selected student")
                        Text("X: Unavailable Seat")
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Seat formatting suggested by ChatGPT
                            ForEach(1...rowNum, id: \.self) { row in
                                if row < rowNum{
                                    ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber <= 2 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, student: student!, seat: seat)
                                    }
                                    
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    
                                    ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber > 2 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, student: student!, seat: seat)
                                    }
                                }
                                else {
                                    ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber == 1 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, student: student!, seat: seat)
                                    }
                                    
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    
                                    ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber > 1 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, student: student!, seat: seat)
                                    }
                                }
                            }
                            
                        }
                        .padding()
                    }
                    .padding(.top, 50)
                    
                }
            }
        }
        .onAppear {
            Task {
                driverInfo = try await obtainDriverInfo(accountID: UserDefaults.standard.integer(forKey: "accountID"))
                busID = driverInfo?.busID ?? 0
                busInfo = try await obtainBusInfo.obtainBusInfo(id: busID)
                rowNum = busInfo?.rowAmount ?? 0
                do {
                    seats = try await getSeats.fetchSeats(busID: busID)
                } catch {
                    print("Failed to fetch seats: \(error)")
                }
                loadingSeats = false
            }
        }
    }
}

struct SeatView: View {
    @Binding var assignmentConfirm: Bool
    var student: Student
    @EnvironmentObject var studentAssignment: StudentAssignment
    @Environment(\.dismiss) var dismiss
    let seat: Seat
    var body: some View {
        Group {
            if seat.isOccupied {
                if seat.studentID == student.id {
                    VStack{
                        Text("C")
                            .font(.system(size: 20))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 15.0, height: 15.0)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
                }
                else {
                    VStack{
                        Text("X")
                            .font(.system(size: 20))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 15.0, height: 15.0)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
                }
            }
            else {
                Button(action: {assignmentConfirm = true; print("\(seat)"); print("\(student.id)")}, label: {
                    VStack{
                        Text("\(seat.rowNumber) \(seat.seatNumber)")
                            .font(.system(size: 7))
                    }
                    .alert("Would you like to assign this student to this seat?", isPresented: $assignmentConfirm) {
                        Button("Yes", role: .destructive) {
                            Task {
                                dismiss()
                                do {
                                    try await studentAssignment.assignStudent(seat: seat, studentID: student.id)
                                } catch {
                                    print("Error assigning student: \(error)")
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This action cannot be undone.")
                    }
                    .foregroundStyle(.white)
                    .frame(width: 15.0, height: 15.0)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                })

            }
        }
    }
}

func obtainDriverInfo (accountID: Int) async throws -> Driver{
    guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/drivers/info/\(accountID)") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    print("Status code: \(httpResponse.statusCode)")
    
    let driverInfo = try JSONDecoder().decode(Driver.self, from: data)
    return driverInfo
}


#Preview {
    AssignStudent()
}
