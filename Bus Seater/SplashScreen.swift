//
//  SwiftUIView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/22/24.
//

import SwiftUI

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
                    Text("Bus Seater")
                        .font(.largeTitle)
                        .padding(.top, 250)
                        .padding(.leading, 5)
                }
                Spacer()
            }

    }
}

#Preview {
    SplashScreen()
}
