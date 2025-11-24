//
//  Homepage.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import FirebaseMessaging

struct StudentHomepage: View {
    
    @AppStorage("WasUserLoggedIn") private var WasUserLoggedIn = false
    @AppStorage("accountType") private var accountType = ""
    
    var body: some View {
        ZStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
            Button(action: {logout()}, label: {Text("Logout")})
                .foregroundStyle(.black)
                .padding(.bottom, 700)
                .padding(.leading, 250)
        }
    }
    func logout() {
        WasUserLoggedIn = false
        accountType = ""
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "schoolID")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "accountType")
        defaults.removeObject(forKey: "accountID")
        defaults.set(false, forKey: "WasUserLoggedIn")}
}

#Preview {
    StudentHomepage()
}
