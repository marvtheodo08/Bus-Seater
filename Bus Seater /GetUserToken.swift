//
//  GetUserToken.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/26/25.
//

import Foundation
import FirebaseAuth

class GetUserToken: ObservableObject{
    func getUserToken() async throws -> String{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }

        let token = try await user.getIDTokenResult(forcingRefresh: true).token
        print("\(token)")
        return token
    }
}
