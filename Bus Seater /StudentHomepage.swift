//
//  Homepage.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import FirebaseMessaging

struct StudentHomepage: View {
    
    @EnvironmentObject var logout: Logout
    @EnvironmentObject var getStudentFromID: GetStudentFromID
    @EnvironmentObject var obtainBusInfo: ObtainBusInfo
    @EnvironmentObject var getSeats: GetSeats
    @EnvironmentObject var obtainbusIDfromAccount: ObtainBusIDfromAccount
    @State var loading: Bool = true
    @State private var isSelectionOpen: Bool = false
    @State private var isStudentAllowed: Bool = false
    @State private var unbanDate: Date? = nil
    @State private var studentStrikes: Int = 0
    @State private var student: Student? = nil
    @State private var rowNum: Int = 0
    @State private var seatNum: Int = 0
    @State private var seats = [Seat]()
    @State private var busInfo: Bus? = nil
    @State private var busID: Int = 0
    
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
            if loading {
                VStack {
                    ProgressView("Loading seats...")
                        .multilineTextAlignment(.center)
                }
            }
            else {
                    ZStack{
                        Button(action: {logout.logout()}, label: {Text("Logout")})
                            .foregroundStyle(.black)
                            .padding(.bottom, 700)
                            .padding(.leading, 250)
                        Button(action: {}, label: {Image(systemName: "gearshape.fill")})
                            .foregroundStyle(.gray)
                            .padding(.bottom, 700)
                            .padding(.trailing, 250)
                            .font(.system(size: 20))
                        VStack(alignment: .leading){
                            ScrollView{
                                Text("Legend")
                                    .bold()
                                    .font(.system(size: 30))
                                Text("C: Your current seat")
                                Text("X: Unavailable Seat")
                                LazyVGrid(columns: columns, spacing: 16) {
                                    // Seat formatting suggested by ChatGPT
                                    ForEach(1...rowNum, id: \.self) { row in
                                        if row < rowNum{
                                            ForEach(seats.filter { $0.rowNum == row && $0.seatNumber <= 2 }) { seat in
                                                SeatView(student: student!, seat: seat)
                                            }
                                            
                                            Color.clear
                                                .frame(width: 15, height: 15)
                                            
                                            ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 2 }) { seat in
                                                SeatView(student: student!, seat: seat)
                                            }
                                        }
                                        else {
                                            ForEach(seats.filter { $0.rowNum == row && $0.seatNumber == 1 }) { seat in
                                                SeatView(student: student!, seat: seat)
                                            }
                                            
                                            Color.clear
                                                .frame(width: 15, height: 15)
                                            Color.clear
                                                .frame(width: 15, height: 15)
                                            
                                            ForEach(seats.filter { $0.rowNum == row && $0.seatNumber > 1 }) { seat in
                                                SeatView(student: student!, seat: seat)
                                            }
                                        }
                                    }
                                    
                                }
                                .padding()
                                
                                NavigationLink(destination: StudentSelection(student: student!)) {
                                    Text("Don't have an account? Sign up here!")
                                }
                            }
                            .padding(.top, 50)
                        }
                        
                    }
            }
        }
        .onAppear {
            Task {
                do {
                    student = try await getStudentFromID.getStudentFromID(accountID: UserDefaults.standard.integer(forKey: "accountID"))
                    busID = try await obtainbusIDfromAccount
                        .obtainBusIDfromAccountID(
                            accountType: UserDefaults.standard.string(forKey: "accountType")!, accountID: UserDefaults.standard.integer(forKey: "accountID")
                        )

                    busInfo = try await obtainBusInfo.obtainBusInfo(id: busID)
                    rowNum = busInfo?.rowAmount ?? 0
                    seats = try await getSeats.fetchSeats(busID: busID)
                    
                    loading = false

                } catch {
                    print("Failed to load student homepage:", error)
                }
                
            }
        }
        
    }
    
}

struct SeatView: View {
    var student: Student
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
                Button(action: {}, label: {
                    VStack{
                        Text("\(seat.rowNum), \(seat.seatNumber)")
                            .font(.system(size: 7))
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

#Preview {
    StudentHomepage()
}

