//
//  StudentAssignment.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/13/25.
//

import Foundation

class StudentAssignment: ObservableObject {
    
    func assignStudent(seat: Seat, studentID: Int) async throws {
        
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/update/seat/true/\(seat.busID)/\(seat.rowNumber)/\(seat.seatNumber)/\(studentID)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("\(seat)")
        print("\(studentID)")

    }
    
    func unassignStudent(seat: Seat) async throws {
        guard let url = URL(string: "https://bus-seater-hhd5bscugehkd8bf.canadacentral-01.azurewebsites.net/update/seat/false/\(seat.busID)/\(seat.rowNumber)/\(seat.seatNumber)") else {
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
