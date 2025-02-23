//
//  Bus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/27/24.
//

import Foundation

struct Bus: Identifiable, Codable {
    let id: Int
    let seatAmount: Int
    let busCode: String
    let schoolID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case seatAmount = "seat_amount"
        case busCode = "bus_code"
        case schoolID = "school_id"
    }
    
}
