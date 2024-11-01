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
    // set isSplash bool to true when app is opened
    @State private var isSplash = true
    @EnvironmentObject var lastUserInfo: LastUserInfo
    @EnvironmentObject var notifsPermissions: NotifsPermissions
    var body: some View{
        Group{
            // if isSplash is true, show splash scree 
            if isSplash{
                SplashScreen()
                // make Splasb screen appear with an animation
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            withAnimation(.easeOut(duration: 0.5))
                            {
                                // set splash to false when 
                                isSplash = false
                            }
                            
                        }
                    }
                
            }
            //other wise if isSplash is false
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
        }
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
