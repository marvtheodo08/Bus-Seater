//
//  SeatInfo.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/29/25.
//

import SwiftUI

struct SeatInfo: View {
    @Environment(\.dismiss) var dismiss
    @State private var student: Student? = nil
    var seat: Seat? = nil
    @State private var loading: Bool = false
    var body: some View {
        ZStack{
            if loading{
                VStack {
                    ProgressView("Loading seat info...")
                        .multilineTextAlignment(.center)
                }
            }
            else{
                VStack
                {
                    Text("Row \(seat?.rowNum ?? 0)")
                        .foregroundStyle(.black)
                        .padding()
                    Text("Seat \(seat?.seatNumber ?? 0)")
                        .foregroundStyle(.black)
                        .padding()
                    Text("Currently occupied by: \(student?.firstName ?? "") \(student?.lastName ?? "")")
                        .foregroundStyle(.black)
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
        .onAppear{
            Task{
                let seatID = seat?.id ?? 0
                student = try await getStudentFromSeat(seatID: seatID)
                loading = false
            }
        }
    }
    func getStudentFromSeat(seatID: Int) async throws -> Student{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/getStudentFromSeat?seatID=\(seatID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.mysqlDate)
        
        let seat = try decoder.decode(Student.self, from: data)
        
        return seat
    }
}

#Preview {
    SeatInfo()
}
