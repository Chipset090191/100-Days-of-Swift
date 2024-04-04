//
//  Bundle-Decodable.swift
//  FactsAboutCountries
//
//  Created by Михаил Тихомиров on 08.01.2024.
//

import Foundation

extension Bundle {
    func decode(_ file:String) -> [Country] {
        
        // first we locate our file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // then we load our file
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // and then we decode our file
        // we use .self in [String: Country].self to tell swift that we exactly want to decode to type itself [String: Country]
        guard let decoded = try? JSONDecoder().decode([Country].self, from: data) else {
            fatalError("Failed to decode \(file).")
        }

        return decoded
    }
}
