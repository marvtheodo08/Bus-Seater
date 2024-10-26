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
    @EnvironmentObject var lastUserInfo: LastUserInfo
    @EnvironmentObject var notifsPermissions: NotifsPermissions
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
                              if notifsPermissions.WasPermissionAsked = false{
                                  requestNotificationPermission()
                                  notifsPermissions.WasPermissionAsked == true
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
                print("Permission Granted")
                notifsPermissions.WasPermissionGranted == true
            }
            else{
                print("Permission Denied")
                notifsPermissions.WasPermissionGranted == false
            }
        }
    }

#Preview {
    ContentView()
}
