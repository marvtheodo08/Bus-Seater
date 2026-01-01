//
//  StudentSettings.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/31/25.
//

import SwiftUI

enum AlertType: Identifiable {
    case canGiveStrikes
    case canNotGiveStrikes
    var id: Self { self }
}

struct StudentSettings: View {
    
    var student: Student? = nil
    @EnvironmentObject var getUserToken: GetUserToken
    @State private var assigningStudent = false
    @State private var givingStudentStrike = false
    @State private var strikeGiven = false
    @State private var alertType: AlertType? = nil
    
    var body: some View {
        
        VStack{
            Text("Name: \(student?.firstName ?? "") \(student?.lastName ?? "")")
                .padding()
            Text("Grade: \(student?.grade ?? "")")
                .padding()
            Button(action: {assigningStudent = true}){
                Text("Assign Student")
                    .padding()
            }
            Button(action: {canGiveStrikes(strikes: student?.strikes ?? 0)}){
                Text("Give Student Strike")
                    .foregroundStyle(.red)
            }
        }
        .sheet(isPresented: $assigningStudent){
            SeatSelection(student: student)
        }
        .alert(item: $alertType) { type in
            switch type {
            case .canGiveStrikes:
                Alert(
                    title: Text("Are you sure you want to give this student a strike?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Yes")) {
                        Task {
                            do {
                                print(student?.id ?? 0)
                                try await giveStudentStrike(studentID: student?.id ?? 0)
                                strikeGiven = true
                            } catch {
                                print("Error giving student strike: \(error)")
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )

            case .canNotGiveStrikes:
                Alert(
                    title: Text("Maximum Strikes"),
                    message: Text("You have given this student the maximum strikes for this quarter."),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
        .fullScreenCover(isPresented: $strikeGiven) {
            DriverHomepage()
        }
    }
    func giveStudentStrike(studentID: Int) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/addStrike?studentID=\(studentID)") else {
            throw URLError(.badURL)
        }
        
        let token = try await getUserToken.getUserToken()

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
        
    }
    func canGiveStrikes(strikes: Int) {
        if strikes != 3{
            alertType = .canGiveStrikes
        } else {
            alertType = .canNotGiveStrikes
        }
    }
}

#Preview {
    StudentSettings()
}
