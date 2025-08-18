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
    @State var fetchingBuses = true
    @State var busSelected = false
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var getBuses: GetBuses
    
    // 3 columns = 3 buses per row
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            if fetchingBuses {
                VStack {
                    ProgressView("Loading buses...")
                        .multilineTextAlignment(.center)
                        .colorScheme(.light)
                }
            }
            else {
                if getBuses.buses.isEmpty {
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
                        Button(action: {}, label: {Image(systemName: "gearshape.fill")})
                            .foregroundStyle(.gray)
                            .padding(.bottom, 700)
                            .padding(.trailing, 250)
                            .font(.system(size: 20))
                    }
                    .navigationDestination(isPresented: $AdminAddingBuses) {
                        AddBuses()
                    }
                    .fullScreenCover(isPresented: $userLoggingOut) {
                        Login()
                    }
                }
                else {
                        ZStack{
                            Color(.white)
                                .ignoresSafeArea()
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
                            Button(action: {}, label: {Image(systemName: "gearshape.fill")})
                                .foregroundStyle(.gray)
                                .padding(.bottom, 700)
                                .padding(.trailing, 250)
                                .font(.system(size: 20))
                            VStack(alignment: .leading) {
                                ScrollView{
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(getBuses.buses) { bus in
                                            Button(action: {busSelected = true}, label: {
                                                VStack{
                                                    Image(systemName: "bus")
                                                    Text("\(bus.busCode)")
                                                        .font(.system(size: 12))
                                                }
                                                .foregroundStyle(.white)
                                                .frame(width: 40.0, height: 40.0)
                                                .padding(25)
                                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                            })
                                            .sheet(isPresented: $busSelected, content: {ManageBus()})
                                        }
                                        // ➕ Add Bus button after all buses
                                        Button(action: {AdminAddingBuses = true}, label: {
                                            VStack{
                                                Image(systemName: "plus")
                                                    .foregroundStyle(.gray)
                                                    .font(.system(size: 40))
                                                Text("Add more buses")
                                                    .foregroundStyle(.black)
                                            }
                                        })
                                        
                                    }
                                    .padding()
                                }
                                .padding(.top, 50)

                            }
                            
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
        .onAppear{
            Task{
                do {
                    try await getBuses.fetchBuses(schoolID: UserDefaults.standard.integer(forKey: "schoolID"))
                } catch {
                    print("Failed to fetch buses: \(error)")
                }
                fetchingBuses = false
            }
        }
    }
}

#Preview {
    AdminHomepage()
}
