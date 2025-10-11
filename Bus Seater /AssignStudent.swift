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
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Seat formatting suggested by ChatGPT
                            ForEach(1...rowNum, id: \.self) { row in
                                let columns = 5
                                HStack {
                                    ForEach(1...columns, id: \.self) {column in
                                        if column < 3 && row < rowNum {
                                            ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber < 3 }) { seat in
                                                if seat.isOccupied {
                                                    VStack{
                                                        Text("This seat is taken")
                                                            .font(.system(size: 3))
                                                    }
                                                    .foregroundStyle(.white)
                                                    .frame(width: 15.0, height: 15.0)
                                                    .padding(25)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                                }
                                                else {
                                                    Button(action: {}, label: {
                                                        VStack{
                                                            Text("\(seat.rowNumber) \(seat.seatNumber)")
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
                                        else if column > 3 {
                                            ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber > 2 }) { seat in
                                                if seat.isOccupied {
                                                    VStack{
                                                        Text("This seat is taken")
                                                            .font(.system(size: 3))
                                                    }
                                                    .foregroundStyle(.white)
                                                    .frame(width: 15.0, height: 15.0)
                                                    .padding(25)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                                }
                                                else {
                                                    Button(action: {}, label: {
                                                        VStack{
                                                            Text("\(seat.rowNumber) \(seat.seatNumber)")
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
                                        else if column == 3 || row == rowNum && column == 2{
                                            Color.clear.frame(height: 15.0)
                                        }
                                        else if row == rowNum && column > 3 {
                                            ForEach(seats.filter { $0.rowNumber == row && $0.seatNumber > 1 }) { seat in
                                                if seat.isOccupied {
                                                    VStack{
                                                        Text("This seat is taken")
                                                            .font(.system(size: 3))
                                                    }
                                                    .foregroundStyle(.white)
                                                    .frame(width: 15.0, height: 15.0)
                                                    .padding(25)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                                }
                                                else {
                                                    Button(action: {}, label: {
                                                        VStack{
                                                            Text("\(seat.rowNumber) \(seat.seatNumber)")
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
                                }
                                
                            }
                            .padding()
                        }
                        .padding(.top, 50)
                        
                    }
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
}

#Preview {
    AssignStudent()
}
