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

struct BusID: Codable {
    let busID: Int
    enum CodingKeys: String, CodingKey {
        case busID = "bus_id"
    }
}

class ObtainBusIDfromAccount: ObservableObject {
    func obtainBusIDfromAccountID(accountID: Int) async throws -> Int {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/driver/busID/\(accountID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let busID = try JSONDecoder().decode(BusID.self, from: data)
        return busID.busID
    }
}

class ObtainBusInfo: ObservableObject {
    func obtainBusInfo(id: Int) async throws -> Bus {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/bus/info/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let busInfo = try JSONDecoder().decode(Bus.self, from: data)
        return busInfo
    }
}

class ObtainBusID: ObservableObject {
    @Published var id: BusID?
    
    @MainActor
    func obtainBusID(bus_code: String, school_id: Int) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/bus/id/\(school_id)/\(bus_code)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let busID = try JSONDecoder().decode(BusID.self, from: data)
        self.id = busID
        print(busID)
    }
}

class GetBuses: ObservableObject {
    func fetchBuses(schoolID: Int) async throws -> [Bus]{
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/buses/\(schoolID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let fetchedbuses = try JSONDecoder().decode([Bus].self, from: data)
        
        return fetchedbuses
    }
}
