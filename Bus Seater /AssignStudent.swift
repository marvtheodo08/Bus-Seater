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
    @State private var driverInfo: Driver? = nil
    @State private var busInfo: Bus? = nil
    @State private var busID: Int = 0
    @State var loadingSeats = true
    @State private var rows: Int = 0
    @State private var seats: Int = 0
    
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
                rows = busInfo?.rowAmount ?? 0
                seats = busInfo?.seatCount ?? 0
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
