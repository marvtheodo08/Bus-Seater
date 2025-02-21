//
//  File.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 2/21/25.
//

import Foundation
import Combine

class NewAccount: ObservableObject {
    
    class Account: Codable {
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
    
    @Published var account = [Account]()
    private var cancellables = Set<AnyCancellable>()
    
    //Function prompted by ChatGPT
    func addAccount(_ account: Account) {
        guard let url = URL(string: "https://http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/account/create") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(account)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Response code: \(httpResponse.statusCode)")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }
        }
        task.resume()
    }
    
}


    
    


