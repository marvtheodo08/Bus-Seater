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
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let defaults = UserDefaults.standard
        if appState.isUserLoggedIn {
            switch defaults.string(forKey: "accountType"){
            case "admin":
                AdminHomepage()
            case "driver":
                DriverHomepage()
            default:
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
