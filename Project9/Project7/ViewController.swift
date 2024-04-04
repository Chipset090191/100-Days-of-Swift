//
//  ViewController.swift
//  Project7
//
//  Created by Михаил Тихомиров on 19.11.2023.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var urlString: String {
        if navigationController?.tabBarItem.tag == 0 {
            return "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            return "https://hackingwithswift.com/samples/petitions-2.json"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "White house Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(Credits))
        
        // we run this code on Background
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    @objc func fetchJSON() {

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // we `re here to parse some data
                    parse(json: data)
                    return
                }
            }
        // we run this code on main thread
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            
    }
    
    
    
    
    @objc func Credits() {
        let ac = UIAlertController(title: "Info", message: "The data comes from the: We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showError() {
        
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            // we run this code on main thread
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            // we run this code on main thread
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController() // here we do not initiate View Controller just create an instance
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

