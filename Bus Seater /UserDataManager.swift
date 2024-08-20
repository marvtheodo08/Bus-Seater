//
//  UserDataManager.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/19/24.
//

import Foundation
import SQLite

class DatabaseManager: ObservableObject {
    private var db: Connection?

    init() {
        copyDatabaseIfNeeded()
        connectToDatabase()
    }

    private func copyDatabaseIfNeeded() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let databaseURL = documentDirectory.appendingPathComponent("userdata.db")

        if !fileManager.fileExists(atPath: databaseURL.path) {
            if let bundleURL = Bundle.main.url(forResource: "userdata", withExtension: "db") {
                do {
                    try fileManager.copyItem(at: bundleURL, to: databaseURL)
                } catch {
                    print("Error copying database file: \(error)")
                }
            }
        }
    }

    private func connectToDatabase() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let databaseURL = documentDirectory.appendingPathComponent("userdata.db")

        do {
            db = try Connection(databaseURL.path)
        } catch {
            print("Error connecting to database: \(error)")
        }
    }

}

