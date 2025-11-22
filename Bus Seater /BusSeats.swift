//
//  BusSeats.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/17/25.
//

import Foundation

struct Seat: Identifiable, Codable {
    let seatNumber: Int
    let rowNumber: Int
    let busID: Int
    let studentID: Int?
    let isOccupied: Bool
    
    var id: String {
        "\(busID).\(rowNumber).\(seatNumber)"
    }
}

struct NewSeat: Codable {
    var busID: Int
    var rowNumber: Int
    var seatNumber: Int
    
    init(busID: Int, rowNumber: Int, seatNumber: Int) {
        self.busID = busID
        self.rowNumber = rowNumber
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
