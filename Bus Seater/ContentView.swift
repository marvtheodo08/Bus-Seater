//
//  ContentView.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/21/24.
//

import SwiftUI
import SwiftData




struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
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
                .onAppear(){
                    addSchools()
                }
        }
    }
    func addSchools()
    {
        let schools =
        [school(school_name: "South Shore Charter Public School", municipality: "Norwell", state: "MA")]
        for school in schools {
            modelContext.insert(school)
        }
    }

}
#Preview {
    ContentView()
}
