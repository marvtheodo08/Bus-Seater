//
//  Bus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation

struct Bus: Identifiable, Codable {
    let id: Int
    let seatAmount: Int
    let busCode: String
    let schoolID: Int
    let rowAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case seatAmount = "seat_amount"
        case busCode = "bus_code"
        case schoolID = "school_id"
        case rowAmount = "row_amount"
    }
    
}

class GetBuses: ObservableObject {
    @Published var buses = [Bus]()
    
    @MainActor
    func fetchBus(schoolID: Int) async throws {
        guard let url = URL(string: "http://busseater-env-1.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/buses/\(schoolID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let fetchedbuses = try JSONDecoder().decode([Bus].self, from: data)
        
        // Update the @Published property
        self.buses = fetchedbuses
    }
}
