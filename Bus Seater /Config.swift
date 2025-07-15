//
//  Config.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 7/15/25.
//

enum Environment {
    case simulator
    case device
    case production

    static var current: Environment {
        #if DEBUG
            #if targetEnvironment(simulator)
            return .simulator
            #else
            return .device
            #endif
        #else
            return .production
        #endif
    }

    var apiBaseURL: String {
        switch self {
        case .simulator:
            return "http://localhost:3000"
        case .device:
            return "http://73.219.37.55:3000" // dev device testing
        case .production:
            return "https://api.myapp.com"   // production backend
        }
    }
}
