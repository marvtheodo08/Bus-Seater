//
//  Homepage.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct StudentHomepage: View {
    @State var userLoggingOut = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
            Button(action: {userLoggingOut = true
                appState.isUserLoggedIn = false
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "firstName")
                defaults.removeObject(forKey: "lastName")
                defaults.removeObject(forKey: "schoolID")
                defaults.removeObject(forKey: "email")
                defaults.removeObject(forKey: "accountType")
                defaults.removeObject(forKey: "accountID")
                defaults.set(false, forKey: "WasUserLoggedIn")}, label: {Text("Logout")})
                .foregroundStyle(.black)
                .padding(.bottom, 700)
                .padding(.leading, 250)
        }
        .fullScreenCover(isPresented: $userLoggingOut) {
            Login()
        }
    }
}

#Preview {
    StudentHomepage()
}
