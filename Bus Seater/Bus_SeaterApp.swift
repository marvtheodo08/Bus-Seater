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
@StateObject private var lastUserInfo = LastUserInfo()
@StateObject private var schoolDataAppended = SchoolDataAppended()
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .environmentObject(lastUserInfo)
        }

    }

