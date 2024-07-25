//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isSplash = true
    @EnvironmentObject var lastUserInfo: LastUserInfo
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
                if lastUserInfo.WasUserLoggedIn == false
                {
                    Login()
                          .onAppear{
                              if !UserDefaults.standard.bool(forKey: "NotifsPermissionaAsked"){
                                  requestNotificationPermission()
                                  UserDefaults.standard.set(true, forKey: "NotifsPermissionaAsked")
                              }
                          }
                }
                else{
                    Homepage()
                }
            }
        }
        .onAppear {
           if !UserDefaults.standard.bool(forKey: "SchoolDataInserted") {
               addSchools()
               UserDefaults.standard.set(true, forKey: "SchoolDataInserted")
               
           }
            
        
       }

    }
    func addSchools() {
        let schools = [
            school(school_name: "South Shore Charter Public School", municipality: "Norwell", state: "MA")]
        
        for school in schools {
            modelContext.insert(school)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if granted {
                print("Granted")
            }
            else{
                print("Permission Denied")
            }
        }
    }
}

#Preview {
    ContentView()
}
