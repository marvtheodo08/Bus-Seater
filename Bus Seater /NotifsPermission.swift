//
//  NotifsPermission.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import Foundation

class NotifsPermissions: ObservableObject{
    @Published var WasPermissionAsked: Bool = false
    @Published var WasPermissionGranted: Bool = nil
}
