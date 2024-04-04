//
//  ViewController.swift
//  FactsAboutCountries
//
//  Created by Михаил Тихомиров on 08.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    let countries: [Country] = Bundle.main.decode("Countries.json")
    
    var countryDetailedInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facts of Countries"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomedCell", for: indexPath)
        
        // then we use our customed Cell here
        if let cell = cell as? CountryCustomedCell {
            
            cell.customedLabel.text = countries[indexPath.row].country // here we get a value of every key
            cell.customedImageView.image = UIImage(named: countries[indexPath.row].country)
            cell.customedImageView.layer.borderColor = UIColor.gray.cgColor
            cell.customedImageView.layer.borderWidth = 1
            cell.customedImageView.layer.cornerRadius = 9
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let chosenElement = countries[indexPath.row].country
        
  
        for everyElement in countries {
            if everyElement.country == chosenElement {
                countryDetailedInfo.append(everyElement.capital)
                countryDetailedInfo.append(everyElement.size)
                countryDetailedInfo.append(everyElement.population)
                countryDetailedInfo.append(everyElement.currency)
                countryDetailedInfo.append(everyElement.description)
                countryDetailedInfo.append(everyElement.infoTest[1].language ?? "-")
            }
        }
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailTableViewController {
            vc.countryInfo = countryDetailedInfo
            navigationController?.pushViewController(vc, animated: true)
            countryDetailedInfo.removeAll()
        }
    }
    
    
    


}

