//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI


struct ContentView: View {
    @State private var isSplash = true
    var body: some View{
        if isSplash{
            SplashScreen()
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        withAnimation(.easeOut(duration: 0.5))
                        {
                            isSplash = false
                        }
                        
                    }
                }
            
        }
        else
        {
            Login()
        }
    }
}
#Preview {
    ContentView()
}
