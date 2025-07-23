//
//  AppState.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 7/23/25.
//

import Foundation

class AppState: ObservableObject {
    @Published var path: [Route] = []
    @Published var isUserLoggedIn = UserDefaults.standard.bool(forKey: "WasUserLoggedIn")
}
