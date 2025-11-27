//
//  Bus_SeaterApp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        
        return true
    }
}


@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var getSchools = GetSchools()
  @StateObject private var newAccount = NewAccount()
  @StateObject private var obtainAccountInfo = ObtainAccountInfo()
  @StateObject private var getBuses = GetBuses()
  @StateObject private var obtainBusInfo = ObtainBusInfo()
  @StateObject private var obtainBusID = ObtainBusID()
  @StateObject private var busActions = BusActions()
  @StateObject private var obtainbusIDfromAccount = ObtainBusIDfromAccount()
  @StateObject private var getSeats = GetSeats()
  @StateObject private var studentAssignment = StudentAssignment()
  @StateObject private var logout = Logout()
  @StateObject private var getUserToken = GetUserToken()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .preferredColorScheme(.light)
      }
      .environmentObject(getSchools)
      .environmentObject(newAccount)
      .environmentObject(obtainAccountInfo)
      .environmentObject(getBuses)
      .environmentObject(obtainBusInfo)
      .environmentObject(obtainBusID)
      .environmentObject(busActions)
      .environmentObject(obtainbusIDfromAccount)
      .environmentObject(getSeats)
      .environmentObject(studentAssignment)
      .environmentObject(logout)
      .environmentObject(getUserToken)
    }
  }
}

