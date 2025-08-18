//
//  BusSeats.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/17/25.
//

import Foundation

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
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/seat/create/") else { fatalError("Invalid URL") }
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
