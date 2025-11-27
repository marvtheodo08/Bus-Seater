//
//  Homepage.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI
import FirebaseMessaging

struct StudentHomepage: View {
    
    @EnvironmentObject var logout: Logout
    
    var body: some View {
        ZStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
            Button(action: {logout.logout()}, label: {Text("Logout")})
                .foregroundStyle(.black)
                .padding(.bottom, 700)
                .padding(.leading, 250)
        }
    }
}

#Preview {
    StudentHomepage()
}
