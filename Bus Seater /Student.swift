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
