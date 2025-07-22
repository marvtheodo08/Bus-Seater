//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import Firebase
import UserNotifications

// Navigation Route sugguested by ChatGPT
enum Route: Hashable {
    case login
    case signup
    case studentSignUp
    case driverSignUp
    case adminSignUp
}

struct ContentView: View {
    @State private var path: [Route] = []
    @State private var isUserLoggedIn = UserDefaults.standard.bool(forKey: "WasUserLoggedIn")
    @EnvironmentObject var notifsPermissions: NotifsPermissions
    
    var body: some View {
        NavigationStack(path: $path) {
            let defaults = UserDefaults.standard
            Group{
                // If there was a user logged in
                if defaults.bool(forKey: "WasUserLoggedIn") == true{
                    // If that user was an admin
                    if defaults.string(forKey: "accountType") == "admin"{
                        // Display Admin Homepage
                        AdminHomepage(isUserLoggedIn: $isUserLoggedIn, path: $path)
                    }
                    // Otherwise if the user was a driver
                    else if defaults.string(forKey: "accountType") == "driver"{
                        // Display Driver Homepage
                        DriverHomepage(isUserLoggedIn: $isUserLoggedIn, path: $path)
                    }
                    // Else Display the Student Homepage
                    else {
                        StudentHomepage(isUserLoggedIn: $isUserLoggedIn, path: $path)
                    }
                }
                // Otherwise
                else{
                    //make Login screen appear
                    Login(path: $path)
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login: Login(path: $path)
                case .signup: SignUp(path: $path)
                case .studentSignUp: Student_SignUp()
                case .driverSignUp: Driver_SignUp()
                case .adminSignUp: Admin_SignUp()
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
