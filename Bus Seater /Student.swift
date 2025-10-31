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

struct NewStudent: Codable {
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
