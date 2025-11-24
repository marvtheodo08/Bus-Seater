//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import Firebase
import UserNotifications

struct ContentView: View {
    
    @AppStorage("WasUserLoggedIn") private var WasUserLoggedIn = false
    @AppStorage("accountType") private var accountType = ""

    var body: some View {
            if WasUserLoggedIn{
                if accountType == "admin"{
                    AdminHomepage()
                }
                else if accountType == "driver"{
                    DriverHomepage()
                }
                else if accountType == "student"{
                    StudentHomepage()
                }
            }
            else {
                Login()
            }
    }
    
}

#Preview {
    ContentView()
}
