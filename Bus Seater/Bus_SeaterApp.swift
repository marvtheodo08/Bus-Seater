//
//  Bus_SeaterApp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import SwiftData


@main
struct Bus_SeaterApp: App {
@StateObject private var userSettings = UserSettings()
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .environmentObject(userSettings)
            .modelContainer(for: [student.self, driver.self, school.self, bus.self, admin.self])
        }

    }

