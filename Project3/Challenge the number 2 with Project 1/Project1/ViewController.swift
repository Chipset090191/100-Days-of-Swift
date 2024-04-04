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
        
        //MARK: Chellenge 2.1 (share info about this app to others)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareInfo))
        
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: Chellenge 2.2 (share info about this app to others)
    @objc func shareInfo() {

          let message = "Look at this awesome app!"
          let appLink = "https://my_app"
          let objectToShare = [message, appLink]
        
        
        let vc = UIActivityViewController(activityItems: objectToShare, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
}

