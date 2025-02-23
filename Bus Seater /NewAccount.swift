//
//  File.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 2/21/25.
//

import Foundation

class NewAccount: ObservableObject {
    
    struct Account: Codable {
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
        
        init(firstName: String, lastName: String, email: String, accountType: String, schoolID: Int) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.accountType = accountType
            self.schoolID = schoolID
        }
        
    }
    
    //Function prompted by ChatGPT
    func addAccount(_ account: Account) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/account/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(account)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
}


    
    


