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
    @EnvironmentObject var obtainbusIDfromAccount: ObtainBusIDfromAccount
    @State private var driverInfo: Driver? = nil
    @State private var busInfo: Bus? = nil
    @State private var busID: Int = 0
    @State var loadingSeats = true
    @State private var rowNum: Int = 0
    @State private var seatNum: Int = 0
    @State private var seats = [Seat]()
    @State private var assignmentConfirm = false
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
                                    ForEach(seats.filter { $0.rowNum == row && $0.seatNumber <= 2 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, selectedSeat: $selectedSeat, student: student!, seat: seat)
                                    }
                                    
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    
                                    ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 2 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, selectedSeat: $selectedSeat, student: student!, seat: seat)
                                    }
                                }
                                else {
                                    ForEach(seats.filter { $0.rowNum == row && $0.seatNumber == 1 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, selectedSeat: $selectedSeat, student: student!, seat: seat)
                                    }
                                    
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    Color.clear
                                        .frame(width: 15, height: 15)
                                    
                                    ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 1 }) { seat in
                                        SeatView(assignmentConfirm: $assignmentConfirm, selectedSeat: $selectedSeat, student: student!, seat: seat)
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
                busID = try await obtainbusIDfromAccount.obtainBusIDfromAccountID(accountID: UserDefaults.standard.integer(forKey: "accountID"))
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
    @Binding var selectedSeat: Seat?
    var student: Student
    @EnvironmentObject var studentAssignment: StudentAssignment
    @Environment(\.dismiss) var dismiss
    let seat: Seat
    var body: some View {
        Group {
            if seat.isOccupied {
                if seat.studentId == student.id {
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
                Button(action: {selectedSeat = seat; assignmentConfirm = true; print("\(seat)"); print("\(student.id)")}, label: {
                    VStack{
                        Text("\(seat.rowNum) \(seat.seatNumber)")
                            .font(.system(size: 7))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 15.0, height: 15.0)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                })
                .alert("Would you like to assign this student to row \(selectedSeat?.rowNum ?? 0), seat \(selectedSeat?.seatNumber ?? 0)?", isPresented: $assignmentConfirm) {
                    Button("Yes", role: .destructive) {
                        Task {
                            dismiss()
                            do {
                                try await studentAssignment.assignStudent(seat: selectedSeat!, studentID: student.id)
                            } catch {
                                print("Error assigning student: \(error)")
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }

            }
        }
    }
}


#Preview {
    AssignStudent()
}
