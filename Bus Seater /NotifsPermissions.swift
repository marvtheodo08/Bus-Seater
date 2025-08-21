//
//  NotifsPermissions.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 10/26/24.
//

import Foundation

@MainActor
class NotifsPermissions: ObservableObject{
    @Published var WasPermissionAsked: Bool = false
    @Published var WasPermissionGranted: Bool = false
}
