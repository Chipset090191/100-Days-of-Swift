//
//  ViewController.swift
//  Project1
//
//  Created by Михаил Тихомиров on 31.10.2023.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the place for title and its variations
        title = "Storm Viewer"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OurCell", for: indexPath) as! ImageCell
        cell.name.text = pictures[indexPath.item]
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        
        
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pictures.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Picture is the name of our cell!
//        cell.textLabel?.text = pictures[indexPath.row]
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//            vc.selectedImage = pictures[indexPath.row]
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
}

