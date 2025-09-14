//
//  SchoolNames.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/10/24.
//

import Foundation

struct School: Identifiable, Codable {
    let id: Int
    let schoolName: String
    let municipality: String
    let state: String
    let stateAbriviation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case schoolName = "school_name"
        case municipality
        case state
        case stateAbriviation = "state_abriviation"
    }
    
}
class GetSchools: ObservableObject {
    func fetchSchools(state: String) async throws -> [School]{
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/\(state)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let fetchedSchools = try JSONDecoder().decode([School].self, from: data)
        
        return fetchedSchools
    }
}
