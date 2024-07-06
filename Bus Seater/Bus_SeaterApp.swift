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
                .onAppear{
                    if !UserDefaults.standard.bool(forKey: "preDataInserted") {
                        addSchools()
                        UserDefaults.standard.set(true, forKey: "preDataInserted")
                    }
                }
        }
        .modelContainer(for: [student.self, driver.self, school.self, bus.self])
    }
}

func addSchools()
{
    @Environment(\.modelContext) var modelContext
    let schools =
    [school(school_name: "South Shore Charter Public School", municipality: "Norwell", state: "MA")]
    for school in schools {
        modelContext.insert(school)
    }
}


