//
//  Bus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation

struct Bus: Identifiable, Codable {
    let id: Int
    let seatCount: Int
    let busCode: String
    let schoolID: Int
    let rowAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case seatCount = "seat_count"
        case busCode = "bus_code"
        case schoolID = "school_id"
        case rowAmount = "row_amount"
    }
    
}

class ObtainBusInfo: ObservableObject {
    @Published var bus = [Bus]()
    
    @MainActor
    func obtainBusInfo(id: String) async throws {
        guard let url = URL(string: "http://busseater-env-1.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/bus/info/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let busInfo = try JSONDecoder().decode([Bus].self, from: data)
        self.bus = busInfo
        print(busInfo)
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
class NewBus: ObservableObject {
    
    struct Bus: Codable {
        var rowAmount: Int
        var seatCount: Int
        var busCode: String
        var schoolID: Int
        
        enum CodingKeys: String, CodingKey {
            case rowAmount = "row_amount"
            case seatCount = "seat_count"
            case busCode = "bus_code"
            case schoolID = "account_type"
        }
        
        init(rowAmount: Int, seatCount: Int, busCode: String, schoolID: Int) {
            self.rowAmount = rowAmount
            self.seatCount = seatCount
            self.busCode = busCode
            self.schoolID = schoolID
        }
        
    }
    
    //Function prompted by ChatGPT
    func addBus(_ bus: Bus) async throws {
        guard let url = URL(string: "http://busseater-env-1.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/bus/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(bus)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
}
