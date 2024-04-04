//
//  Country.swift
//  FactsAboutCountries
//
//  Created by Михаил Тихомиров on 08.01.2024.
//

import Foundation

//struct Country:Codable {
//    let country:String
//    let capital:String
//    let size:String
//    let population:String
//    let currency:String
//    let description:String
//    let info_test: [[String:String]]?
//}


struct Country: Codable {
    let country, capital, size, population: String
    let currency, description: String
    let infoTest: [InfoTest]

    enum CodingKeys: String, CodingKey {
        case country, capital, size, population, currency, description
        case infoTest = "info_test"
    }
}

// MARK: - InfoTest
struct InfoTest: Codable {
    let aboutPeople, language: String?

    enum CodingKeys: String, CodingKey {
        case aboutPeople = "about_people"
        case language
    }
}


