//
//  StudentUserVerification.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation
import Combine

struct Student: Identifiable, Codable {
    let id: Int
    let busCode: String
    let schoolID: Int
    let grade: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case busCode = "bus_code"
        case schoolID = "school_id"
        case grade
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
