//
//  ViewController.swift
//  Project2
//
//  Created by Михаил Тихомиров on 03.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var score_label: UILabel!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var countOfQuestions = 0 // default state of questions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
                button1.layer.borderWidth = 1
                button2.layer.borderWidth = 1
                button3.layer.borderWidth = 1
        
                button1.layer.borderColor = UIColor.lightGray.cgColor  // here we choose UIColor and then the light but we must convert it to cgColor because borederColor is CGColor
                button2.layer.borderColor = UIColor.lightGray.cgColor
                button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // when we ask first time there is no action
        askQuestion(action: nil)
            }
    
    // we send the action because this methid calls from Alert controller
    func askQuestion(action: UIAlertAction!) {
                countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
                
                
                button1.setImage(UIImage(named: countries[0]), for: .normal)
                button2.setImage(UIImage(named: countries[1]), for: .normal)
                button3.setImage(UIImage(named: countries[2]), for: .normal)
                
                
                // that`s our correct answer we choose match with flag
                title = countries[correctAnswer].uppercased()
        
                // Score info
                // MARK: Challenge 1 of Project 2
                score_label.text="Score: \(score)"
            }
    
    // we connected our buttons to collection
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title:String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            // MARK: Challenge 3 of Project 2
            title = "Wrong! That is \(countries[sender.tag].uppercased())"
            if score > 0 {
                score -= 1
            }
        }
        // MARK: Challenge 2 of Project 2
        countOfQuestions += 1 // inc our number of questions
        
        if  countOfQuestions == 12 {
            score_label.text="Score: \(score)"
            countOfQuestions = 0
            
            //MARK: Challenge 2 of Project 12
            if let savedScore = UserDefaults.standard.value(forKey: "score") as? Int {
                if score > savedScore {
                    let finalAC = UIAlertController(title: "That`s done with a new RECORD!", message: "Your final score is \(score)", preferredStyle: .alert)
                    finalAC.addAction(UIAlertAction(title: "Click to start again!", style: .cancel, handler: askQuestion))
                    present(finalAC, animated: true)
                    UserDefaults.standard.setValue(score, forKey: "score")
                    score = 0
                } else {
                    let finalAC = UIAlertController(title: "That`s done", message: "Your final score is \(score)", preferredStyle: .alert)
                    finalAC.addAction(UIAlertAction(title: "Click to start again!", style: .cancel, handler: askQuestion))
                    present(finalAC, animated: true)
                    score = 0
                }
            } else {
                let finalAC = UIAlertController(title: "That`s done", message: "Your final score is \(score)", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "Click to start again!", style: .cancel, handler: askQuestion))
                present(finalAC, animated: true)
                UserDefaults.standard.setValue(score, forKey: "score")
                score = 0
            }
            
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
        
        
    }
    
    
    
    
    
    }


