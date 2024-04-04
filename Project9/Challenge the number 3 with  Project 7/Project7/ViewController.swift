//
//  ViewController.swift
//  Project7
//
//  Created by Михаил Тихомиров on 19.11.2023.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var customPetitions = [Petition]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "White house Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: Challenge 1.1 from Project 7
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(Credits))
        
        //MARK: Challenge 2.1 from Project 7
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(forfilter))
        
    
        let resetButton = UIBarButtonItem(
            barButtonSystemItem: .refresh, 
            target: self,
            action: #selector(reset_filter)
        )
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(forfilter))
        
        navigationItem.rightBarButtonItems = [filterButton, resetButton]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
           urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we `re here to parse some data
                parse(json: data)
                return
            }
        }
            showError()
        
        
        
    }
    
    //MARK: Challenge 1.2 from Project 7
    @objc func Credits() {
        let ac = UIAlertController(title: "Info", message: "The data comes from the: We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    
    @objc func forfilter() {
        
        
        let ac = UIAlertController(title: "Filter", message: "Enter a string to filter by:", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
        
        // TextFieldAction for filter
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            
            self?.filter(for: answer)
            
            
          

        }
        
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // reset to default
   @objc func reset_filter() {
        petitions = customPetitions
        tableView.reloadData()
    }
    
    // //MARK: Challenge 3.1 from Project 9
    func filter(for answer:String) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.petitions = self!.petitions.filter {$0.title.localizedCaseInsensitiveContains(answer)}
        }
        
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
//        tableView.reloadData()
        
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            //MARK: 2 from Project 7
            customPetitions = petitions
            tableView.reloadData()   // then finally we reloaded our data
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

