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
        
        // MARK: Challenge 1.1 from Project 9
        performSelector(inBackground: #selector(fetchData), with: nil)
        
    }
    
        // MARK: Challenge 1.2 from Project 9
    @objc func fetchData() {
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Picture is the name of our cell!
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

