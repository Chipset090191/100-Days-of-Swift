//
//  Person.swift
//  Project10
//
//  Created by Михаил Тихомиров on 13.12.2023.
//

import UIKit

// we`ve used NSObject because that`s a unuversal base class for all Cocoa Touch classes. it`s not needed be inhereted from it in swift but we did it. It gives us some extra behaviors!
class Person: NSObject {
    var name:String
    var image:String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
