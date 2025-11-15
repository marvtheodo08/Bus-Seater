//
//  DriverHomepage.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import SwiftUI

struct DriverHomepage: View {
    @State var userLoggingOut = false
    @State private var studentSelected: Student? = nil
    @State private var students = [Student]()
    @State var fetchingStudents = true
    @State private var accountID: Int = 0
    @State private var busID: Int = 0
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var obtainbusIDfromAccount: ObtainBusIDfromAccount
    
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
                    ProgressView("Loading students...")
                        .multilineTextAlignment(.center)
                }
            }
            else {
                if students.isEmpty {
                    ZStack{
                        NavigationLink(destination: AddStudent()){
                            Image(systemName: "plus")
                                .foregroundStyle(.gray)
                                .font(.system(size: 50))
                        }
                        Text("Add your students here.")
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
                    .fullScreenCover(isPresented: $userLoggingOut) {
                        Login()
                    }
                }
                else {
                    ZStack{
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
                                    ForEach(students) { student in
                                        Button(action: {studentSelected = student}, label: {
                                            VStack{
                                                Image(systemName: "studentdesk")
                                                Text("\(student.firstName) \(student.lastName)")
                                                    .font(.system(size: 8))
                                                Text("\(student.grade)")
                                                    .font(.system(size: 12))
                                            }
                                            .foregroundStyle(.white)
                                            .frame(width: 40.0, height: 40.0)
                                            .padding(25)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                        })
                                        .sheet(item: $studentSelected) {
                                            student in AssignStudent(student: student)
                                        }
                                    }
                                    NavigationLink(destination: AddStudent()){
                                        VStack{
                                            Image(systemName: "plus")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 40))
                                            Text("Add more students")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    
                                }
                                .padding()
                            }
                            .padding(.top, 50)

                        }
                        
                    }
                    .fullScreenCover(isPresented: $userLoggingOut) {
                        Login()
                    }
                }
                
            }
        }
        .onAppear{
            accountID = UserDefaults.standard.integer(forKey: "accountID")
            Task{
                try await Task.sleep(nanoseconds: 1_000_000_000)
                do {
                    busID = try await obtainbusIDfromAccount.obtainBusIDfromAccountID(accountID: accountID)
                    try await fetchStudents(busID: busID)
                } catch {
                    print("Failed to fetch students: \(error)")
                }
                fetchingStudents = false
            }
        }
    }
    func logout() {
        userLoggingOut = true
        appState.isUserLoggedIn = false
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "schoolID")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "accountType")
        defaults.removeObject(forKey: "accountID")
        defaults.set(false, forKey: "WasUserLoggedIn")
    }
    @MainActor
    func fetchStudents(busID: Int) async throws {
        guard let url = URL(string: "\(baseURL)/students?busID=\(busID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let fetchedstudents = try JSONDecoder().decode([Student].self, from: data)
        
        students = fetchedstudents
    }
}

#Preview {
    DriverHomepage()
}
