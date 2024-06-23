//
//  Login.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/23/24.
//

import SwiftUI

struct Login: View {
    var body: some View {
        ZStack {
            Color("Backround Color")
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.primary) // Changed to .primary for a valid style
                
                Text("Hello, World!")
            }
            .padding()
        }
    }
}

#Preview {
    Login()
}
