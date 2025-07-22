//
//  DriverHomepage.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import SwiftUI

struct DriverHomepage: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var path: [Route]
    
    var body: some View {
        ZStack{
            Color(.white)
                .ignoresSafeArea()
            Button(action: {}, label: {
                 Image(systemName: "plus")
                    .foregroundStyle(.gray)
                    .font(.system(size: 50))
            })
            Text("Add your students here.")
                .foregroundStyle(.black)
                .padding(.top, 120)
            Button(action: {
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
    }
}

#Preview {
    DriverHomepage(isUserLoggedIn: .constant(true), path: .constant([]))
}
