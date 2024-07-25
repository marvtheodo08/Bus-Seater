//
//  LastUserInfo.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import Foundation

class LastUserInfo: ObservableObject{
    @Published var WasUserLoggedIn: Bool = false
    @Published var LastUserLoggedIn: String = ""
}
