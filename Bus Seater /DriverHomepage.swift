//
//  DriverHomepage.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import SwiftUI

struct DriverHomepage: View {
    @State var userLoggingOut = false
    @State var DriverAddingStudent = false
    @State private var studentSelected: Bus? = nil
    @State var fetchingStudents = true
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var getStudents: GetStudents
    
    // 3 columns = 3 buses per row
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            if fetchingStudents {
                VStack {
                    ProgressView("Loading buses...")
                        .multilineTextAlignment(.center)
                        .colorScheme(.light)
                }
            }
            else {
                if getStudents.students.isEmpty {
                    ZStack{
                        Color(.white)
                            .ignoresSafeArea()
                        Button(action: {DriverAddingStudent = true}, label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.gray)
                                .font(.system(size: 50))
                        })
                        Text("Add your buses here.")
                            .foregroundStyle(.black)
                            .padding(.top, 120)
                        Button(action: {logout()}, label: {Text("Logout")})
                        .foregroundStyle(.black)
                        .padding(.bottom, 700)
                        .padding(.leading, 250)
                        Button(action: {}, label: {Image(systemName: "gearshape.fill")})
                            .foregroundStyle(.gray)
                            .padding(.bottom, 700)
                            .padding(.trailing, 250)
                            .font(.system(size: 20))
                    }
                    .navigationDestination(isPresented: $DriverAddingStudent) {
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
                        Button(action: {logout()}, label: {Text("Logout")})
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
                                    ForEach(getStudents.students) { student in
                                        Button(action: {studentSelected = student}, label: {
                                            VStack{
                                                Image(systemName: "bus")
                                            }
                                            .foregroundStyle(.white)
                                            .frame(width: 40.0, height: 40.0)
                                            .padding(25)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                        })
                                        .sheet(item: $studentSelected) {
                                            student in ManageBus(bus: student)
                                        }
                                    }
                                    // ➕ Add Bus button after all buses
                                    Button(action: {DriverAddingStudent = true}, label: {
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
                    .navigationDestination(isPresented: $DriverAddingStudent) {
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
                try await Task.sleep(nanoseconds: 1_000_000_000)
                do {
                    try await getStudents.fetchStudents(schoolID: UserDefaults.standard.integer(forKey: "schoolID"))
                } catch {
                    print("Failed to fetch buses: \(error)")
                }
                fetchingStudents = false
            }
        }
    }
    func logout() {
        userLoggingOut = true
        appState.isUserLoggedIn = false
        appState.path = []
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "schoolID")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "accountType")
        defaults.removeObject(forKey: "accountID")
        defaults.set(false, forKey: "WasUserLoggedIn")
    } 
}

#Preview {
    DriverHomepage()
}
