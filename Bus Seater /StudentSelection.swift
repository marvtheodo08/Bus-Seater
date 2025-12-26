//
//  StudentSelection.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/24/25.
//

import SwiftUI

struct StudentSelection: View {
    
    var student: Student? = nil
    @State var loading: Bool = true
    @State private var isSelectionOpen: Bool = false
    @State private var isStudentAllowed: Bool = false
    @State private var unbanDate: Date? = nil
    @State private var studentStrikes: Int = 0
    
    var body: some View {
        
        NavigationStack{
            if loading{
                VStack {
                    ProgressView("Loading...")
                        .multilineTextAlignment(.center)
                }
            }
            else{
                if isStudentAllowed{
                    if !isSelectionOpen{
                        ZStack{
                            Text("Selection not available yet. Check back soon!")
                                .foregroundStyle(.black)
                        }
                    }
                    else{
                        SeatSelection(student: student!)
                    }
                }
                else{
                    if studentStrikes < 3{
                        ZStack{
                            Text("Sorry, you can't pick your seat for next week.")
                                .foregroundStyle(.black)
                        }
                    }
                    else{
                        ZStack{
                            Text("Sorry, you can't pick your seat for the rest of the quarter.")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task{
                let defaults = UserDefaults.standard
                let schoolID = defaults.integer(forKey: "schoolID")
                do {
                    isSelectionOpen = try await checkSelection(schoolID: schoolID)
                } catch {
                    print("Failed to check selection: \(error)")
                    isSelectionOpen = false
                }
                
                studentStrikes = student?.strikes ?? 0
                
                if let unbanDate = student?.unbanDate{
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(identifier: "America/New_York")!

                    let today = calendar.startOfDay(for: Date())
                    let unbanDay = calendar.startOfDay(for: unbanDate)
                    
                    if today < unbanDay{
                        isStudentAllowed = false
                    }
                }
                else {
                    if studentStrikes == 3{
                        isStudentAllowed = false
                    }
                    else{
                        isStudentAllowed = true
                    }
                }
                
                loading = false
                                
            }
        }
    }
    func checkSelection(schoolID: Int) async throws -> Bool{
        guard let url = URL(string: "https://bus-seater-api.onrender.com/check_seat_selection?schoolID=\(schoolID)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let isSelectionOpen = try decoder.decode(Bool.self, from: data)
        
        return isSelectionOpen
    }
}

#Preview {
    StudentSelection()
}
