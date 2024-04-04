//
//  AccessData.swift
//  LovelyPhotoAlbum
//
//  Created by Михаил Тихомиров on 24.12.2023.
//

import Foundation

extension Bundle {
    var documentsDirectory:URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}


