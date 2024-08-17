//
//  SwiftUIView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/22/24.
//

import SwiftUI
import Firebase

struct SplashScreen: View {
    var body: some View {
            ZStack {
                Color("Backround Color")
                    .ignoresSafeArea()
                
                ZStack(alignment: .center) {
                    Spacer()
                    Image("App Logo")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 30)
                    Text("Bus Seater")
                        .font(.largeTitle)
                        .padding(.top, 205)
                        .padding(.leading, 5)
                }
                Spacer()
            }

    }
}

#Preview {
    SplashScreen()
}
