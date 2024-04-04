//
//  ViewController.swift
//  Notes
//
//  Created by Михаил Тихомиров on 07.02.2024.
//

import UIKit

class ViewController: UITableViewController, DetailViewControllerDelegate {
    
    func sendDataBack(data: Note, forDelete:Bool, wasChanged:Bool) {
        
        if forDelete == false && wasChanged == false {
            // when adding
            notes.append(data)
            ManageData.save(notes: notes)
        } else if forDelete == true && wasChanged == false {
            // when deleting
            if let index = notes.firstIndex(where: { $0.uuid == data.uuid}) {
                notes.remove(at: index)
            }
            ManageData.save(notes: notes)
        } else if forDelete == false && wasChanged == true {
            // when changing
            ManageData.save(notes: notes)
        }

        tableView.reloadData()
    }
    
    
    var notes = [Note]()
    lazy var calculations = Calculations()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
    
        tableView.allowsMultipleSelectionDuringEditing = false
        
        // we change all indicators that`s inside navigationBar to Yellow color
        navigationController?.navigationBar.tintColor = .systemYellow
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:
                                UIImage(systemName: "square.and.pencil"),
                                style: .plain,
                                target: self,
                                action: #selector(createNote))
        
        // Then we load data from UserDefaults
        notes = ManageData.load()
        
    }
    



    
    @objc func createNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.delegate = self
            vc.calculations = calculations
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].name
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.noteItem = notes[indexPath.row]
            vc.delegate = self
            vc.calculations = calculations
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = notes[indexPath.row]
        
        // this action for deleting object
        let action1 = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            self?.sendDataBack(data: note, forDelete: true, wasChanged: false)
        }
        
        action1.image = UIImage(systemName: "trash.fill")
        action1.backgroundColor = .systemRed
        
        // this action for sharing our note
        let action2 = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            self?.noteForShare(note: note)
        }
        
        action2.image = UIImage(systemName: "square.and.arrow.up")
        action2.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [action1, action2])
        
        return configuration
    }
    
    
    func noteForShare(note: Note) {
        let message = note.description
        let ojectToShare = [message]
        
        let vc = UIActivityViewController(activityItems: ojectToShare, applicationActivities: [])
        present(vc, animated: true)
    }
    
}

