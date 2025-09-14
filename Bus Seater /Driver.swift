//
//  Driver.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 9/14/25.
//

import Foundation

struct Driver: Identifiable, Codable {
    let id: Int
    let accountID: Int
    let schoolID: Int
    let busID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "account_id"
        case schoolID = "school_id"
        case busID = "bus_id"
    }
    
}
