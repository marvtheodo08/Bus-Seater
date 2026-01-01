//
//  StudentUserVerification.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation

struct Student: Identifiable, Codable {
    let id: Int
    let busId: Int
    let schoolId: Int
    let grade: String
    let firstName: String
    let lastName: String
    let unbanDate: Date?
    let strikes: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        busId = try container.decode(Int.self, forKey: .busId)
        schoolId = try container.decode(Int.self, forKey: .schoolId)
        grade = try container.decode(String.self, forKey: .grade)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        strikes = try container.decode(Int.self, forKey: .strikes)

        if let dateString = try container.decodeIfPresent(String.self, forKey: .unbanDate) {
            unbanDate = DateFormatter.mysqlDate.date(from: dateString)
        } else {
            unbanDate = nil
        }
    }
}


struct NewStudent: Codable {
    let busId: Int
    let schoolId: Int
    let grade: String
    let firstName: String
    let lastName: String
    
    init(busId: Int, schoolId: Int, grade: String, firstName: String, lastName: String) {
        self.busId = busId
        self.schoolId = schoolId
        self.grade = grade
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
