//
//  User.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation
import Combine

struct Account: Identifiable, Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let accountType: String
    let schoolID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case accountType = "account_type"
        case schoolID = "school_id"
    }
    
}
