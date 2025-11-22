//
//  TokenManagement.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/21/25.
//

import Foundation

struct TokenUpdateRequest: Codable {
    let token: String
    let accountID: Int
    let accountType: String
}

class AddToToken: ObservableObject {
    func addToToken(token: String, accountID: Int, accountType: String) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/updateTokenInfo?token=\(token)&accountID=\(accountID)&accountType=\(accountType)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let body = TokenUpdateRequest(token: token, accountID: accountID, accountType: accountType)
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

class RemoveFromToken: ObservableObject {
    func removeFromToken(token: String) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/removeTokenInfo?token=\(token)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(token)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
