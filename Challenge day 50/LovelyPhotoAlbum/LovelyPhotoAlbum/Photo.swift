//
//  Photo.swift
//  LovelyPhotoAlbum
//
//  Created by Михаил Тихомиров on 24.12.2023.
//

import Foundation

class Photo:Codable {
    var name:String
    var image:String
    
    init(name:String, image:String) {
        self.name = name
        self.image = image
    }
    
    var imagePath: String {
        return Bundle.main.documentsDirectory.appendingPathComponent(image).path
    }
    
}


