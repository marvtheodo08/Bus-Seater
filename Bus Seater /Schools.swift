//
//  SchoolNames.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/10/24.
//

import Foundation
import Combine

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
    @Published var schools = [School]()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSchools(state: String) async {
        guard let url = URL(string: "busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/\(state)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([School].self, from: data) {
                schools = decodedResponse
            }
        }
        catch {
            print("Error fetching schools: \(error.localizedDescription)")
        }
    }
}
