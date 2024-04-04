//
//  TableViewController.swift
//  Project4
//
//  Created by Михаил Тихомиров on 12.11.2023.
//

import UIKit


// MARK: Challenge 3.1
class TableViewController: UITableViewController {
    
    var web_sites:[String] = []
    
    var constant_web_sites:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        web_sites += ["apple.com", "hackingwithswift.com", "dzen.ru"]
        constant_web_sites = web_sites
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        web_sites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cell.textLabel?.text = web_sites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Web") as? ViewController{
            
            let selectedSite = web_sites[indexPath.row]
            
            web_sites.remove(at: indexPath.item)
            web_sites.insert(selectedSite, at: 0)
            
            vc.websites += web_sites
            web_sites = constant_web_sites
            
        
            
            

            navigationController?.pushViewController(vc, animated: true)
        }
            
        
    }

}
