//
//  NotifsPermissionsAsked.swift
//  Bus Seater
//
//  Created by Esther Fleurmond on 7/25/24.
//

import Foundation

class NotifsPermission: ObservableObject{
    @Published var WasPermissionAsked: Bool = false
    @Published var WasPermissionGranted: Bool = false
}
