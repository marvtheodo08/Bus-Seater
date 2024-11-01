//
//  LastUserInfo.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/24/24.
//

import Foundation

class LastUserInfo: ObservableObject{
    @Published var WasUserLoggedIn: Bool = false
    @Published var Email: String = ""
    @Published var Firstname: String = ""
    @Published var Lastname: String = ""
    @Published var AccountType: String = ""
}
