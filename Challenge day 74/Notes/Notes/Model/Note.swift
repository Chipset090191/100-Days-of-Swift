//
//  Note.swift
//  Notes
//
//  Created by Михаил Тихомиров on 07.02.2024.
//

import Foundation

class Note:Codable {
    let uuid:UUID
    var name:String
    var description:String
    
    init(uuid: UUID,name: String, description: String) {
        self.uuid = uuid
        self.name = name
        self.description = description
    }
}
