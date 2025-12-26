//
//  AssignStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/30/25.
//

import SwiftUI

struct SeatSelection: View {
    var student: Student? = nil
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
    @EnvironmentObject var studentAssignment: StudentAssignment
    @Environment(\.dismiss) var dismiss
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
                Button(action: {selectedSeat = seat; selectionConfirm = true; print("\(seat)"); print("\(student.id)")}, label: {
                    VStack{
                        Text("\(seat.rowNum) \(seat.seatNumber)")
                            .font(.system(size: 7))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 15.0, height: 15.0)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                })
                .alert(alertMessage, isPresented: $selectionConfirm) {
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
    SeatSelection()
}
