//
//  Person.swift
//  Project10
//
//  Created by Михаил Тихомиров on 13.12.2023.
//

import UIKit

// we`ve used NSObject because that`s a unuversal base class for all Cocoa Touch classes. it`s not needed be inhereted from it in swift but we did it. It gives us some extra behaviors!


// we use class here because struct can`t work with NSCoding! And so the reason using NSObject - it`s required to use NSCoding!
class Person: NSObject, NSCoding {
    var name:String
    var image:String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // The code below is needed because we use NSKeyedArchiver tool!
    
    
    // reading from disc
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    // writing to disc
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
}
