//
//  AdminHomepage.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import SwiftUI

struct AdminHomepage: View {
    @State var userLoggingOut = false
    @State var AdminAddingBuses = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color(.white)
                    .ignoresSafeArea()
                Button(action: {AdminAddingBuses = true}, label: {
                     Image(systemName: "plus")
                        .foregroundStyle(.gray)
                        .font(.system(size: 50))
                })
                Text("Add your buses here.")
                    .foregroundStyle(.black)
                    .padding(.top, 120)
                Button(action: { userLoggingOut = true
                    appState.isUserLoggedIn = false
                    appState.path = []
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
            .navigationDestination(isPresented: $AdminAddingBuses) {
                AddBuses()
            }
            .fullScreenCover(isPresented: $userLoggingOut) {
                Login()
            }
        }
    }
}

#Preview {
    AdminHomepage()
}
