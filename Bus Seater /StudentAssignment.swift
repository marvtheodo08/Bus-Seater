//
//  StudentAssignment.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/13/25.
//

import Foundation

class StudentAssignment: ObservableObject {
    
    func assignStudent(seat: Seat, studentID: Int) async throws {
        
        guard let url = URL(string: "https://bus-seater-api.onrender.com/updateSeatTrue?studentID=\(studentID)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(seat)
        } catch {
            print("Failed to encode parameters: \(error)")
        }

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("\(seat)")
    }
    
    func unassignStudent(seat: Seat) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/updateSeatFalse") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

    }
    
}
