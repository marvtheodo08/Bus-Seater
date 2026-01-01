//
//  BusSeats.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/17/25.
//

import Foundation

struct Seat: Identifiable, Codable {
    let seatNumber: Int
    let rowNum: Int
    let busId: Int
    let studentId: Int?
    let isOccupied: Bool
    let id: Int
}

struct NewSeat: Codable {
    var busId: Int
    var rowNum: Int
    var seatNumber: Int
    
    init(busId: Int, rowNum: Int, seatNumber: Int) {
        self.busId = busId
        self.rowNum = rowNum
        self.seatNumber = seatNumber
    }
    
}

class GetSeats: ObservableObject {
    func fetchSeats(busID: Int) async throws -> [Seat]{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/seats?busID=\(busID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let fetchedbuses = try decoder.decode([Seat].self, from: data)
        
        return fetchedbuses
    }
}
