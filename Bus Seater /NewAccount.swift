//
//  NewAccount.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/24/24.
//

import Foundation
import Combine

class Account: Codable, ObservableObject {
    var firstName: String
    var lastName: String
    var email: String
    var accountType: String
    var schoolID: Int
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case accountType = "account_type"
        case schoolID = "school_id"
    }
    
}

class NewAccount: ObservableObject {
    @Published var newAccount: Account? // Single account instead of an array
    private var cancellables = Set<AnyCancellable>()
    
    func createAccount(newAccount: Account) async throws -> Account {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/create/account/admin") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(newAccount)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Account.self, from: data)
    }
}



