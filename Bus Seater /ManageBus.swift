//
//  ManageBus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/18/25.
//

import SwiftUI

struct ManageBus: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var busActions: BusActions
    @EnvironmentObject var getUserToken: GetUserToken
    var bus: Bus? = nil
    @State private var doubleCheck = false
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack
            {
                Button(action: {doubleCheck = true} , label: {Text("Delete Bus")
                    .foregroundStyle(.red)})
            }
            .alert("Are you sure you want to delete this bus?", isPresented: $doubleCheck) {
                Button("Yes", role: .destructive) {
                    Task {
                        do {
                            try await deleteBus(bus: bus!)
                            dismiss()
                        } catch {
                            print("Error deleting bus: \(error)")
                        }
                        busActions.busDeleted = true
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            Button(action: {dismiss()}, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })

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
