//
//  AdminHomepage.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import SwiftUI

struct AdminHomepage: View {
    @State var UserloggingOut = false
    @EnvironmentObject var lastUserInfo: LastUserInfo
    
    var body: some View {
        ZStack{
            Color(.white)
                .ignoresSafeArea()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
            Button(action: {UserloggingOut = true}, label: {Text("Logout")})
                .foregroundStyle(.black)
                .padding(.bottom, 700)
                .padding(.leading, 250)
        }
        .fullScreenCover(isPresented: $UserloggingOut) {
            Login()
                .onAppear() {
                    lastUserInfo.WasUserLoggedIn = false
                }
        }
    }
}

#Preview {
    AdminHomepage()
}
