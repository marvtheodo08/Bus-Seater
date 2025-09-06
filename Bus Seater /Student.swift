//
//  StudentUserVerification.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation

struct Student: Identifiable, Codable {
    let id: Int
    let busID: Int
    let schoolID: Int
    let grade: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case busID = "bus_id"
        case schoolID = "school_id"
        case grade
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}

class NewStudent: ObservableObject {
    struct Student: Codable {
        let busID: Int
        let schoolID: Int
        let grade: String
        let firstName: String
        let lastName: String
        
        enum CodingKeys: String, CodingKey {
            case busID = "bus_id"
            case schoolID = "school_id"
            case grade
            case firstName = "first_name"
            case lastName = "last_name"
        }
        
        init(busID: Int, schoolID: Int, grade: String, firstName: String, lastName: String) {
            self.busID = busID
            self.schoolID = schoolID
            self.grade = grade
            self.firstName = firstName
            self.lastName = lastName
        }
        
    }
    
    //Function modeled from ChatGPT
    func addStudent(_ student: Student) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/student/create/") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(student)
        } catch {
            print("Failed to encode parameters: \(error)")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
    }
    
}
