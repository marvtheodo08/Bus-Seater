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
    
    enum CodingKeys: String, CodingKey {
        case seatNumber = "seat_number"
        case rowNumber = "row_num"
        case busID = "bus_id"
        case studentID = "student_id"
        case isOccupied = "is_occupied"
    }
    
}

class GetSeats: ObservableObject {
    func fetchSeats(busID: Int) async throws -> [Seat]{
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/seats/\(busID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let fetchedbuses = try JSONDecoder().decode([Seat].self, from: data)
        
        return fetchedbuses
    }
}
