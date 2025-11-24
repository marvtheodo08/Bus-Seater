//
//  BusRows.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/30/25.
//

import Foundation

struct NewRow: Codable {
    var rowNum: Int
    var seatCount: Int
    var busId: Int
    
    init(rowNum: Int, seatCount: Int, busId: Int) {
        self.rowNum = rowNum
        self.seatCount = seatCount
        self.busId = busId
    }
    
}
