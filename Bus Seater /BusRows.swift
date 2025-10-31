//
//  BusRows.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/30/25.
//

import Foundation

struct NewRow: Codable {
    var rowNumber: Int
    var seatCount: Int
    var busID: Int
    
    enum CodingKeys: String, CodingKey {
        case rowNumber = "row_num"
        case seatCount = "seat_count"
        case busID = "bus_id"
    }
    
    init(rowNumber: Int, seatCount: Int, busID: Int) {
        self.rowNumber = rowNumber
        self.seatCount = seatCount
        self.busID = busID
    }
    
}
