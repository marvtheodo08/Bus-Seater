//
//  GetStudent.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/24/25.
//

import Foundation

class GetStudentFromID: ObservableObject {
    func getStudentFromID(accountID: Int) async throws -> Student{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/getStudentFromID?accountID=\(accountID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.mysqlDate)
        
        let student = try decoder.decode(Student.self, from: data)
        
        return student
    }
}
