//
//  ViewController.swift
//  Notes
//
//  Created by Михаил Тихомиров on 07.02.2024.
//

import UIKit

class ViewController: UITableViewController, DetailViewControllerDelegate {
    func sendDataBack(data: Note) {
        notes.append(data)
        tableView.reloadData()
    }
    
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNote))
    }
    
    @objc func createNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].name
        return cell
    }

}

