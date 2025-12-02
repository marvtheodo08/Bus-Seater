//
//  ViewStudents.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/1/25.
//

import SwiftUI

struct ViewStudents: View {
    @Environment(\.dismiss) var dismiss
    @State private var studentSelected: Student? = nil
    @State private var students = [Student]()
    @State var fetchingStudents = true
    @State private var busID: Int = 0
    var bus: Bus? = nil
    @EnvironmentObject var logout: Logout
    
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
                        Button(action: {dismiss()}, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        })
                        .padding(.bottom, 700)
                        .padding(.leading, 310)
                        
                    }
                }
                else {
                    ZStack{
                        Button(action: {dismiss()}, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        })
                        .padding(.bottom, 700)
                        .padding(.leading, 310)
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
                }
                
            }
        }
        .onAppear{
            Task{
                try await Task.sleep(nanoseconds: 1_000_000_000)
                do {
                    try await fetchStudents(busID: bus?.id ?? 0)
                } catch {
                    print("Failed to fetch students: \(error)")
                }
                fetchingStudents = false
            }
        }
    }
    @MainActor
    func fetchStudents(busID: Int) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/students?busID=\(busID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        print("Status code: \(httpResponse.statusCode)")
        
        let fetchedstudents = try decoder.decode([Student].self, from: data)
        
        students = fetchedstudents
    }
}

#Preview {
    ViewStudents()
}
