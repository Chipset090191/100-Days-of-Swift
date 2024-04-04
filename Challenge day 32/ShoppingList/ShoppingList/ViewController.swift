//
//  ViewController.swift
//  ShoppingList
//
//  Created by Михаил Тихомиров on 18.11.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var listOfGoods = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // that1s preferencess for our title
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(cleanList))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareList = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(Share))
        
        // added and activate Toolbar with items
        toolbarItems = [spacer, shareList]
        navigationController?.isToolbarHidden = false
    }
    
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter the name:", message: nil, preferredStyle: .alert)
        
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self,weak ac] _ in
            guard let Text_inside = ac?.textFields?[0].text else { return }  // first, if the name of good doesn`t exist we simply return
            
            self?.listOfGoods.insert(Text_inside, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    @objc func Share() {
        if listOfGoods.isEmpty {
            return
        } else {
            let nameOfList = "My Shopping List"
            let list = listOfGoods.joined(separator: "\n")
            let combined = [nameOfList, list]
            let avc = UIActivityViewController(activityItems: combined, applicationActivities: [])
            present(avc, animated: true)
        }
    }
    
    @objc func cleanList() {
        listOfGoods.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfGoods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Good", for: indexPath)
        cell.textLabel?.text = listOfGoods[indexPath.row]
        return cell
    }
    
    // example of how to change background
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
                cell.backgroundColor = UIColor.green
            }
        
    }


}

