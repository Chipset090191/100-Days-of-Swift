//
//  DetailViewController.swift
//  Notes
//
//  Created by Михаил Тихомиров on 07.02.2024.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func sendDataBack(data:Note)
}

class DetailViewController: UIViewController {

    
    @IBOutlet var note: UITextView!
    
    weak var delegate: DetailViewControllerDelegate?
    
    var noteItem:Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail Info"
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !note.text.isEmpty {
            if let noteText = note.text {
                let words = noteText.components(separatedBy: " ")
                let firstWord = words[0]
                let note = Note(name: firstWord, description: noteText)
                delegate?.sendDataBack(data: note)
            }

        }
    }
    
    @objc func done() {
        if note.text.isEmpty {
            navigationController?.popViewController(animated: true)
        }
    }
    


}
