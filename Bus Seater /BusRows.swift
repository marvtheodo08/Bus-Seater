//
//  BusRows.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/3/25.
//

import Foundation

class NewRow: ObservableObject {
    
    struct Row: Codable {
        var rowNumber: Int
        var seatCount: Int
        var busID: Int
        
        enum CodingKeys: String, CodingKey {
            case rowNumber = "row_num"
            case seatCount = "seat_count"
            case busID = "bus_id"
        }
        
        init(rowNumber: Int, seatCount: Int, busID: Int) {
            self.rowNumber = rowNumber
            self.seatCount = seatCount
            self.busID = busID
        }
        
    }
    
    //Function prompted by ChatGPT
    func addRow(_ row: Row) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/row/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(row)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
}
