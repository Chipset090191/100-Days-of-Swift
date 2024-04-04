//
//  ViewController.swift
//  Project1
//
//  Created by Михаил Тихомиров on 31.10.2023.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the place for title and its variations
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        

        if let defaults = UserDefaults.standard.data(forKey: "pictures") {
            if let data = try? JSONDecoder().decode([Picture].self, from: defaults) {
                pictures = data
            }
        } else {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    let pic = Picture(name: item, countOfView: 0)
                    pictures.append(pic)
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Picture is the name of our cell!
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "Count of views: \(String(pictures[indexPath.row].countOfView))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].name
            pictures[indexPath.row].countOfView += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(pictures) {
            UserDefaults.standard.set(savedData, forKey: "pictures")
        }
        
    }
    
}

