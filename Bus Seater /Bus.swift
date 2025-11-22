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
}

struct BusID: Codable {
    let busID: Int
}

struct NewBus: Codable {
    var rowAmount: Int
    var seatCount: Int
    var busCode: String
    var schoolID: Int

    init(rowAmount: Int, seatCount: Int, busCode: String, schoolID: Int) {
        self.rowAmount = rowAmount
        self.seatCount = seatCount
        self.busCode = busCode
        self.schoolID = schoolID
    }
    
}

class ObtainBusIDfromAccount: ObservableObject {
    func obtainBusIDfromAccountID(accountID: Int) async throws -> Int {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/driverBusID?accountID=\(accountID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let busID = try decoder.decode(BusID.self, from: data)
            return busID.busID
        }
    }
}

class ObtainBusInfo: ObservableObject {
    func obtainBusInfo(id: Int) async throws -> Bus {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/busInfo?id=\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Bus.self, from: data)
        }
    }
}

class ObtainBusID: ObservableObject {
    @MainActor
    func obtainBusID(bus_code: String, school_id: Int) async throws -> Int{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/bus?schoolID=\(school_id)&busCode=\(bus_code)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let busID = try decoder.decode(BusID.self, from: data)
        return busID.busID
    }
}

class GetBuses: ObservableObject {
    func fetchBuses(schoolID: Int) async throws -> [Bus]{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/buses?schoolID=\(schoolID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let fetchedbuses = try decoder.decode([Bus].self, from: data)
        
        return fetchedbuses
    }
}
