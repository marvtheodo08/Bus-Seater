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
    @EnvironmentObject var notifsPermissions: NotifsPermissions
    
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
                //When Login screen appears
                    .onAppear{
                        //if NotifsPermission was not ask
                        if notifsPermissions.WasPermissionAsked == false{
                            //Ask NotifsPermission
                            requestNotificationPermission()
                            //Change that Permission was asked
                            Task{
                                notifsPermissions.WasPermissionAsked = true
                            }
                        }
                    }
            }
        
    }
    // Function for asking Notifs Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if granted {
                print("Permission Granted")
                Task{
                    await changetoTrue()
                }
            }
            else{
                print("Permission Denied")
                Task{
                    await changetoFalse()
                }
            }
        }
    }
    
    @MainActor
    func changetoTrue(){
        notifsPermissions.WasPermissionGranted = true
    }
    
    @MainActor
    func changetoFalse(){
        notifsPermissions.WasPermissionGranted = false
    }
    
    
}

#Preview {
    ContentView()
}
