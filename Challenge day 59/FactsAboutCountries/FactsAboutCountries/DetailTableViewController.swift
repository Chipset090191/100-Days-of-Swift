//
//  DetailTableViewController.swift
//  FactsAboutCountries
//
//  Created by Михаил Тихомиров on 08.01.2024.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var countryInfo:[String]!
    
    let captions = ["Capital", "Size", "Population", "Currency", "Description", "Language"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detailed View"
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countryInfo.removeAll()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath)
        cell.textLabel?.text = captions[indexPath.row]
        cell.detailTextLabel?.text = countryInfo[indexPath.row]
        return cell
    }

}
