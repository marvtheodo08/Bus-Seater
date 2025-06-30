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
    @EnvironmentObject var notifsPermissions: NotifsPermissions
    var body: some View{
        let defaults = UserDefaults.standard
        // If there was a user logged in
        if defaults.bool(forKey: "WasUserLoggedIn") == true{
            // If that user was an admin
            if defaults.string(forKey: "accountType") == "admin"{
                // Display Admin Homepage
                AdminHomepage()
            }
            // Otherwise if the user was a driver
            else if defaults.string(forKey: "accountType") == "driver"{
                // Display Driver Homepage
                DriverHomepage()
            }
            // Else Display the Student Homepage
            else {
                StudentHomepage()
            }
        }
        // Otherwise
        else{
            //make Login screen appear
            Login()
            //When Login screen appears
                .onAppear{
                    //if NotifsPermission was not ask
                    if notifsPermissions.WasPermissionAsked == false{
                        //Ask NotifsPermission
                        requestNotificationPermission()
                        //Change that Permission was asked
                        notifsPermissions.changeAskedtoTrue()
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
                notifsPermissions.changeGrantedtoTrue()
            }
            else{
                print("Permission Denied")
                notifsPermissions.WasPermissionGranted = false
            }
        }
    }
         
        
       }

#Preview {
    ContentView()
}
