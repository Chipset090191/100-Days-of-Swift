//
//  Beacon.swift
//  Project22
//
//  Created by Михаил Тихомиров on 14.02.2024.
//

import Foundation

struct Beacon {
    var uuid: UUID
    var major: UInt16
    var minor: UInt16
    var identifier: String
    
    init(uuid: UUID, major: UInt16, minor: UInt16, identifier: String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.identifier = identifier
    }
}
