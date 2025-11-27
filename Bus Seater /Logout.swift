//
//  Logout.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/25/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

class Logout: ObservableObject{
    @AppStorage("accountType") private var accountType: String = ""
    @AppStorage("WasUserLoggedIn") private var WasUserLoggedIn = false
    func logout(){
        WasUserLoggedIn = false
        accountType = ""
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "schoolID")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "accountID")
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
