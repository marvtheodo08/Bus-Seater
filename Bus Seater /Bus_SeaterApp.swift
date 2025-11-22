//
//  Bus_SeaterApp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        Messaging.messaging().delegate = self
        
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM Token:", token)
        sendTokenToServer(token)
    }
    
    func sendTokenToServer(_ token: String) {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/register_token") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["token": token]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request).resume()
    }
}


@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var getSchools = GetSchools()
  @StateObject private var newAccount = NewAccount()
  @StateObject private var obtainAccountInfo = ObtainAccountInfo()
  @StateObject private var appState = AppState()
  @StateObject private var getBuses = GetBuses()
  @StateObject private var obtainBusInfo = ObtainBusInfo()
  @StateObject private var obtainBusID = ObtainBusID()
  @StateObject private var busActions = BusActions()
  @StateObject private var obtainbusIDfromAccount = ObtainBusIDfromAccount()
  @StateObject private var getSeats = GetSeats()
  @StateObject private var studentAssignment = StudentAssignment()
  @StateObject private var addToToken = AddToToken()
  @StateObject private var removeFromToken = RemoveFromToken()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .preferredColorScheme(.light)
      }
      .environmentObject(getSchools)
      .environmentObject(newAccount)
      .environmentObject(obtainAccountInfo)
      .environmentObject(appState)
      .environmentObject(getBuses)
      .environmentObject(obtainBusInfo)
      .environmentObject(obtainBusID)
      .environmentObject(busActions)
      .environmentObject(obtainbusIDfromAccount)
      .environmentObject(getSeats)
      .environmentObject(studentAssignment)
      .environmentObject(addToToken)
    }
  }
}

