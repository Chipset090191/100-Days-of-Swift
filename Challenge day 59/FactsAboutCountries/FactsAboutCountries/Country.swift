//
//  Country.swift
//  FactsAboutCountries
//
//  Created by Михаил Тихомиров on 08.01.2024.
//

import Foundation

struct Country:Codable {
    let country:String
    let capital:String
    let size:String
    let population:String
    let currency:String
    let description:String
    let info_test: [[String:String]]?
}
