//
//  LastUserInfo.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import Foundation

struct Account: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var accountType: String
    var schoolID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case accountType = "account_type"
        case schoolID = "school_id"
    }
}

class ObtainAccountInfo: ObservableObject {
    @Published var account = [Account]()
    
    @MainActor
    func obtainAccountInfo(email: String) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/account/info/\(email)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let accountInfo = try JSONDecoder().decode([Account].self, from: data)
        self.account = accountInfo
        print(accountInfo)
    }
}
