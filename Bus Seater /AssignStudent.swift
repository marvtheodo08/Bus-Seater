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
                            ForEach(seats) { seat in
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
                do {
                    seats = try await getSeats.fetchSeats(busID: busID)
                } catch {
                    print("Failed to fetch seats: \(error)")
                }
                loadingSeats = false
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
