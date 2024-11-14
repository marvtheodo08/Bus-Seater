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
                Color("Background Color")
                    .ignoresSafeArea()
                
                ZStack(alignment: .center) {
                    Spacer()
                    Image("App Logo")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 80)
                    Text("Bus Seater")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 205)
                        .padding(.leading, 5)
                        .foregroundStyle(.black)
                }
                Spacer()
            }

    }
}

#Preview {
    SplashScreen()
}
