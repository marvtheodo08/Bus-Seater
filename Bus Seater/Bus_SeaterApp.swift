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
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .modelContainer(for: [student.self, driver.self, school.self, bus.self, admin.self])
        }

    }

