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
    var schoolId: Int
}

class ObtainAccountInfo: ObservableObject {
    @MainActor
    func obtainAccountInfo(email: String) async throws -> Account{
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/accountInfo?email=\(email)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let accountInfo = try decoder.decode(Account.self, from: data)
        print(accountInfo)
        return accountInfo
    }
}
