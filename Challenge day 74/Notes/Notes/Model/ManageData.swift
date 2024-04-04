//
//  ManageData.swift
//  Notes
//
//  Created by Михаил Тихомиров on 08.02.2024.
//

import Foundation

class ManageData {
    static func save(notes: [Note]) {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        } else {
            print ("Failed to encode data to UserDefault!")
        }
    }
    
    static func load() -> [Note] {
        let jsonDecoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "notes") {
            if let decodedData = try? jsonDecoder.decode([Note].self, from: data) {
                return decodedData
            } else {
                print ("Failed to decode data from UserDefault!")
            }
        }
        return []
    }
}
