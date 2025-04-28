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
    
    init(id: Int, firstName: String, lastName: String, email: String, accountType: String, schoolID: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accountType = accountType
        self.schoolID = schoolID
    }
    
}

class LastUserInfo: ObservableObject{
    @Published var WasUserLoggedIn: Bool = false
    @Published var Email: String = ""
    @Published var Firstname: String = ""
    @Published var Lastname: String = ""
    @Published var AccountType: String = ""
    @Published var accountID: Int = 0
    @Published var schoolID: Int = 0
}

class ObtainAccountInfo: ObservableObject {
    @Published var account: Account?
    
    @MainActor
    func obtainAccountInfo(email: String) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/account/info/\(email)/") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let accountInfo = try JSONDecoder().decode(Account.self, from: data)
        
        self.account = accountInfo
        if let account = account {
            print(account)
        }
    }
}
