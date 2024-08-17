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
    @State private var isSplash = true
    @State private var notifsAllowed = UserDefaults.standard.bool(forKey: "notifsAllowed")
    var body: some View{
        Group{
            if isSplash{
                SplashScreen()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            withAnimation(.easeOut(duration: 0.5))
                            {
                                isSplash = false
                            }
                            
                        }
                    }
                
            }
            else{
                    Login()
                          .onAppear{
                              if !UserDefaults.standard.bool(forKey: "NotifsAsked"){
                                  requestNotificationPermission()
                                  UserDefaults.standard.set(true, forKey: "NotifsAsked")
                              }
                          }
                }
            }
        }
         
        
       }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if granted {
                print("Granted")
                UserDefaults.standard.setValue(true, forKey: "notifsAllowed")
            }
            else{
                print("Permission Denied")
                UserDefaults.standard.setValue(false, forKey: "notifsAllowed")
            }
        }
    }

#Preview {
    ContentView()
}
