//
//  ManageBus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/18/25.
//

import SwiftUI

struct ManageBus: View {
    @EnvironmentObject var busActions: BusActions
    @EnvironmentObject var getUserToken: GetUserToken
    var bus: Bus? = nil
    @State private var doubleCheck = false
    var body: some View {
        ZStack{
            VStack
            {
                NavigationLink(destination: ViewStudents(bus: bus)){
                    Text("View Students")
                        .foregroundStyle(.black)
                        .padding()
                }
                Button(action: {doubleCheck = true} , label: {Text("Delete Bus")
                    .foregroundStyle(.red)})
            }
            .alert("Are you sure you want to delete this bus?", isPresented: $doubleCheck) {
                Button("Yes", role: .destructive) {
                    Task {
                        do {
                            try await deleteBus(bus: bus!)
                            busActions.busDeleted = true
                        } catch {
                            print("Error deleting bus: \(error)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .fullScreenCover(isPresented: $busActions.busDeleted){
            AdminHomepage()
        }
    }
    func deleteBus(bus: Bus) async throws {
        guard let url = URL(string: "https://bus-seater-api.onrender.com/deleteBus?id=\(bus.id)") else {
            throw URLError(.badURL)
        }
        

        let token = try await getUserToken.getUserToken()

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // 2. Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
        
    }
}

#Preview {
    ManageBus()
}
