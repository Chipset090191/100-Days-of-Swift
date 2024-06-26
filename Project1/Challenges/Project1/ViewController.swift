//
//  ViewController.swift
//  Project1
//
//  Created by Михаил Тихомиров on 31.10.2023.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the place for title and its variations
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        // MARK: Challenge 2.1
        pictures = pictures.sorted{$0 < $1}
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            // MARK: Challenge 3.1
            vc.Collection = pictures.count
            vc.NumberOfCollection = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

