//
//  SeatSelectionCheck.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/21/25.
//

import Foundation

struct IsSelectionOpen: Codable {
    let isSelectionOpen: Bool
}

class SelectionCheck: ObservableObject {
    func selectionCheck(schoolID: Int) async throws -> Bool {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/check_seat_selection?schoolID=\(schoolID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let isSelectionOpen = try JSONDecoder().decode(IsSelectionOpen.self, from: data)
        return isSelectionOpen.isSelectionOpen
    }
}
