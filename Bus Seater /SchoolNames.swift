//
//  SchoolNames.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/9/24.
//

import Foundation
import Combine

struct School: Identifiable, Codable {
    var id = UUID()
    let school_name: String
    
    enum CodingKeys: String, CodingKey {
        case school_name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.school_name = try container.decode(String.self, forKey: .school_name)
        self.id = UUID()
    }
}
class GetSchools: ObservableObject {
    @Published var schools: [School] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSchools(state: String) {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/schools/\(state)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [School].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.schools, on: self)
            .store(in: &cancellables)
            print("Fetched schools:", self.schools)
    }
}
