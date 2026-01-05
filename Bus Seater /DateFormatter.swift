//
//  DateFormatter.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/21/25.
//

import Foundation

//extension created by ChatGPT
extension DateFormatter {
    static let mysqlDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "America/New_York")
        return f
    }()
}
