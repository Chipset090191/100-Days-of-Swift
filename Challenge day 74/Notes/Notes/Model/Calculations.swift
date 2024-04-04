//
//  Calculations.swift
//  Notes
//
//  Created by Михаил Тихомиров on 10.02.2024.
//

import Foundation
class Calculations {
    
    func actionsForNote(note:String?, noteItem:Note?, delegate: DetailViewControllerDelegate?, isTrashed:Bool) {
        guard let newText = note else { return }
        var firstWord = ""
       
        
        let words = newText.components(separatedBy: " ")  // finding
        
        if words.count <= 3 {
            for element in 0..<words.count {
                firstWord += "\(words[element]) "
            }
        } else {
           firstWord = words[0]
        }
    
        
        if noteItem == nil && newText.isEmpty {
            return
        } else if noteItem == nil && !newText.isEmpty {
            // adding
            
            let note = Note(uuid: UUID(), name: firstWord, description: newText)
            delegate?.sendDataBack(data: note, forDelete: false, wasChanged: false)
            
        } else if noteItem != nil && newText.isEmpty || isTrashed == true {
            // deleting
            delegate?.sendDataBack(data: noteItem!, forDelete: true, wasChanged: false)
        } else if noteItem != nil && !newText.isEmpty {
            // save changes when note was edited or oppened
            noteItem?.name = firstWord
            noteItem?.description = newText
            delegate?.sendDataBack(data: noteItem!, forDelete: false, wasChanged: true)
        }
        
    }

}


