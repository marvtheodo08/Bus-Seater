//
//  Testing.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/2/25.
//

import Foundation

var baseURL: String {
    #if targetEnvironment(simulator)
    return "http://localhost:5001"
    #else
    return "http://10.0.0.44:5001"
    #endif
}
