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
  @StateObject private var newBus = NewBus()
  @StateObject private var obtainBusInfo = ObtainBusInfo()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
      .environmentObject(notifsPermissions)
      .environmentObject(getSchools)
      .environmentObject(newAccount)
      .environmentObject(obtainAccountInfo)
      .environmentObject(appState)
      .environmentObject(getBuses)
      .environmentObject(newBus)
      .environmentObject(obtainBusInfo)
    }
  }
}

