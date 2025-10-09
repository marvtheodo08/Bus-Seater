//
//  BusSeats.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/17/25.
//

import Foundation

struct Seat: Codable {
    let seatNumber: Int
    let rowNumber: Int
    let busID: Int
    let studentID: Int
    let isOccupied: Bool
    
    enum CodingKeys: String, CodingKey {
        case seatNumber = "seat_number"
        case rowNumber = "row_num"
        case busID = "bus_id"
        case studentID = "student_id"
        case isOccupied = "is_occupied"
    }
    
}

class NewSeat: ObservableObject {
    
    struct Seat: Codable {
        var busID: Int
        var rowNumber: Int
        var seatNumber: Int
        
        enum CodingKeys: String, CodingKey {
            case busID = "bus_id"
            case rowNumber = "row_num"
            case seatNumber = "seat_number"
        }
        
        init(busID: Int, rowNumber: Int, seatNumber: Int) {
            self.busID = busID
            self.rowNumber = rowNumber
            self.seatNumber = seatNumber
        }
        
    }
    
    //Function prompted by ChatGPT
    func addSeat(_ seat: Seat) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/seat/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(seat)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
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
