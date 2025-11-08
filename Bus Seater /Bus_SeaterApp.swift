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
  @StateObject private var notifsPermissions = NotifsPermissions()
  @StateObject private var getSchools = GetSchools()
  @StateObject private var newAccount = NewAccount()
  @StateObject private var obtainAccountInfo = ObtainAccountInfo()
  @StateObject private var appState = AppState()
  @StateObject private var getBuses = GetBuses()
  @StateObject private var obtainBusInfo = ObtainBusInfo()
  @StateObject private var obtainBusID = ObtainBusID()
  @State private var obtainbusIDfromAccount = ObtainBusIDfromAccount()
  @State private var getSeats = GetSeats()
  @State private var studentAssignment = StudentAssignment()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .preferredColorScheme(.light)
      }
      .environmentObject(notifsPermissions)
      .environmentObject(getSchools)
      .environmentObject(newAccount)
      .environmentObject(obtainAccountInfo)
      .environmentObject(appState)
      .environmentObject(getBuses)
      .environmentObject(obtainBusInfo)
      .environmentObject(obtainBusID)
      .environmentObject(obtainbusIDfromAccount)
      .environmentObject(getSeats)
      .environmentObject(studentAssignment)
    }
  }
}

