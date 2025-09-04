//
//  BusLayout.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 9/4/25.
//

import SwiftUI

struct BusLayout: View {
    @EnvironmentObject var obtainBusID: AppState
    @State var accountID: Int = 0
    @State var busID: BusID? = nil
    @State var id: Int = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let secondColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    struct BusID: Identifiable, Codable {
        let id: Int
        enum CodingKeys: String, CodingKey {
            case id
        }
        init(id: Int) {
            self.id = id
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    Button(action: {}, label: {
                        VStack {
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
        .onAppear {
            accountID = UserDefaults.standard.integer(forKey: "accountID")
            Task{
                try await obtainBusID(account_id: accountID)
                id = busID?.id ?? 0
            }
        }
    }
    func obtainBusID(account_id: Int) async throws {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/driver/busID/\(account_id)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let id = try JSONDecoder().decode(BusID.self, from: data)
        busID = id
        print(id)
    }
}

#Preview {
    BusLayout()
}
