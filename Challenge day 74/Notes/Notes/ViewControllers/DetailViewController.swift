//
//  DetailViewController.swift
//  Notes
//
//  Created by Михаил Тихомиров on 07.02.2024.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func sendDataBack(data:Note,forDelete:Bool,wasChanged:Bool)
}

class DetailViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet var note: UITextView!
    
    weak var delegate: DetailViewControllerDelegate?
    
    
    var noteItem:Note?
    var calculations:Calculations!
    var isTextChanged = false
    var deleteWasPressed = false
    var doneWasPressed = false
    
    
    var test: Bool = true {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // after delegation we know every event from UITextView
        note.delegate = self
        
        title = "Detail Info"
        navigationItem.largeTitleDisplayMode = .never
    
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteObject))
        navigationItem.rightBarButtonItems = [trashButton]
        trashButton.isEnabled = noteItem == nil ? false:true
        
        
        // toolbarItems that is on the bottom edge
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareNote = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(noteForShare))
        toolbarItems = [spacer, shareNote]
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
        
        // we put noteDescription if the object is not nil
        note.text = noteItem?.description
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Note text has been changed
        if !isTextChanged {
            isTextChanged = true
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            navigationItem.rightBarButtonItems?.insert(doneButton, at: 0)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTextChanged = false
        if doneWasPressed == false && deleteWasPressed == false {
            calculations.actionsForNote(note: note.text, noteItem: noteItem, delegate: delegate, isTrashed: false)
        }
        doneWasPressed = false
        deleteWasPressed = false
    }
    
    @objc func done() {
        doneWasPressed = true
        calculations.actionsForNote(note: note.text, noteItem: noteItem, delegate: delegate, isTrashed: false)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteObject () {
        deleteWasPressed = true
        calculations.actionsForNote(note: note.text, noteItem: noteItem, delegate: delegate, isTrashed: deleteWasPressed)
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func noteForShare() {
        let message = note.text!
        let ojectToShare = [message]
        
        let vc = UIActivityViewController(activityItems: ojectToShare, applicationActivities: [])
        present(vc, animated: true)
    }
    

        

        
        
        

   

}
