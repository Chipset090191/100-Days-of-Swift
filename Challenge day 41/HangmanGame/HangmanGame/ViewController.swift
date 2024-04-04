//
//  ViewController.swift
//  HangmanGame
//
//  Created by Михаил Тихомиров on 06.12.2023.
//

import UIKit

class ViewController: UIViewController {
    enum statusGame {
        case inProgress, win, lose
    }
    
    var answerWord:UILabel!
    var horrorWordUI:UILabel!
    var levelNameUI:UILabel!
    var numberOfLevel:UILabel!
    
    var letterButtons = [UIButton]()
    
    
    let Alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    var numberOfAttempts = 7
    var horrorWord = ["H","A","N","M","A","N"]
    var solutionLetterArray = [String]()     // this is a solution word in the array sequence
    var solutionForCompare = ""
    var solutions = [String]()  // all rest solutions on the level
    
    
    let smilePosition = {
        let str = "HANMAN"
        let position = str.index(str.startIndex, offsetBy: 3)
        return position
    }
    
    var level = 1 {
        didSet {
            numberOfLevel.text = "Level:\(level)"
        }
    }
    
    
    
    var levelName = ""
    
    
    
    var status:statusGame = .inProgress
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        numberOfLevel = UILabel()
        numberOfLevel.translatesAutoresizingMaskIntoConstraints = false
        numberOfLevel.text = "Level:1"
        numberOfLevel.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(numberOfLevel)

        horrorWordUI = UILabel()
        horrorWordUI.translatesAutoresizingMaskIntoConstraints = false
        horrorWordUI.text = ""

        horrorWordUI.font = UIFont(name: "Papyrus", size: 53)
        
        horrorWordUI.textColor = UIColor(red: 0.9, green: 0.2, blue: 0.5, alpha: 1)
        view.addSubview(horrorWordUI)
        
        levelNameUI = UILabel()
        levelNameUI.translatesAutoresizingMaskIntoConstraints = false
        levelNameUI.text = ""
        levelNameUI.numberOfLines = 0
        levelNameUI.font = UIFont(name: "Optima", size: 20)
        view.addSubview(levelNameUI)
        
        answerWord = UILabel()
        answerWord.translatesAutoresizingMaskIntoConstraints = false
        answerWord.text = " "
        answerWord.font = UIFont(name: "Kefa", size: 43)
        answerWord.layer.borderWidth = 1
        answerWord.layer.cornerRadius = 2
        answerWord.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(answerWord)
        
        // here we`ve added our one-single letters emty space!
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // our Layout place
        NSLayoutConstraint.activate ([
            numberOfLevel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            numberOfLevel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        
            horrorWordUI.topAnchor.constraint(equalTo: numberOfLevel.bottomAnchor),
            horrorWordUI.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            levelNameUI.topAnchor.constraint(equalTo: horrorWordUI.bottomAnchor, constant: 50),
            levelNameUI.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            answerWord.topAnchor.constraint(equalTo: levelNameUI.bottomAnchor, constant: 10),
            answerWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: answerWord.bottomAnchor, constant: 50)
        ])
        
//        buttonsView.backgroundColor = .purple
        
        
        
        let width = 60
        let height = 60
        
        var dynamicColumn = 5
        
        // creating buttons here
       
        for row in 0..<6 {
            if row > 3 {
                dynamicColumn = 3
            }
            for column in 0..<dynamicColumn {
                // creating and positioning buttons
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont(name: "Kefa", size: 43)
                letterButton.backgroundColor = .systemCyan
                letterButton.setTitleColor(.black, for: .normal)
                letterButton.layer.cornerRadius = 8.0
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.black.cgColor
                
                letterButton.setTitle("A", for: .normal)
                
                // self in target means that we notify our Class View controller when we tap our letter
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: row <= 3 ? (column * width) + 1 : (column * width) + 61 , y: row * height + 1, width: width - 2, height: height - 2)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                // created an array of our customized buttons with the width and height.
                letterButtons.append(letterButton)
                
                // so as our UIButton`s instances are class instance than It doesn`t matter where we change the property of our instance
                // to assign the letter of alphabet for every button I go through the array of UIbuttons and change the title.
                // UIButton is a class, that means every element of letterButtons just a reference to the source.
                for number in 0..<letterButtons.count {
                    letterButtons[number].setTitle(Alphabet[number], for: .normal)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Here we push our work to the background
        performSelector(inBackground: #selector(loading), with: nil)
    }
    
    
    @objc func letterTapped(_ sender:UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        guard let answerWordUnrapped = answerWord.text else { return }
        // if the user tapped letter we`ve had recently we just return
        if Array(answerWordUnrapped).contains(Character(buttonTitle)) { return }
        
        
        if Array(solutionForCompare).contains(Character(buttonTitle)) {
            sender.setTitleColor(.green, for: .normal)
        }
        
        if solutionLetterArray.contains(buttonTitle) {
        
            answerWord.text = check(buttonTitle: buttonTitle, answerWordUnrapped: answerWordUnrapped)
            if status == .win && !solutions.isEmpty {

                answerWord.backgroundColor = .green
                let ac = UIAlertController(title: "You crafted the word '\(answerWord.text ?? "zero")'", message: "go to the next word click OK", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loading))
                present(ac, animated: true)
            
            } else if status == .win && solutions.isEmpty {
                    levelNameUI.backgroundColor = .green
                    status = .inProgress
                    numberOfAttempts = 7
                    horrorWordUI.text = ""
                if level < 3 {
                    let ac = UIAlertController(title: "You crafted the Level \(level)", message: "go to the next level click OK", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loading))
                    present(ac, animated: true)
                    level += 1
                } else {
                    let ac = UIAlertController(title: "You are done with this Game!", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "New game", style: .default, handler: loading))
                    present(ac, animated: true)
                    level = 1
                }
                    
                    
            }
 
        } else if numberOfAttempts != 0 {
            // "HAN😈MAN"
            if numberOfAttempts != 1 {
                horrorWordUI.text! += horrorWord[7 - numberOfAttempts]
                numberOfAttempts -= 1
            } else {
                horrorWordUI.text?.insert(Character("😈"), at: smilePosition())
                numberOfAttempts -= 1
            }
        }
        
        if numberOfAttempts == 0 {
            status = .lose
            let ac = UIAlertController(title: "You were executed!", message: "to reload the game click OK", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loading))
            present(ac, animated: true)
        }
        
 
        
    }
    
    
    func check(buttonTitle:String, answerWordUnrapped:String)->String {
        var answerWordUnrappedModified = answerWordUnrapped
        
        for index in 0..<solutionLetterArray.count {
            if buttonTitle == solutionLetterArray[index] {
                let position = answerWordUnrapped.index(answerWordUnrapped.startIndex, offsetBy: index)
                answerWordUnrappedModified.remove(at: position)
                answerWordUnrappedModified.insert(Character(buttonTitle), at: position)
            }
        }
        if answerWordUnrappedModified == solutionForCompare {
            status = .win
            return answerWordUnrappedModified
        } else {
            return answerWordUnrappedModified
        }
        
    }
    

    @objc func loading(action:UIAlertAction) {
        
        var questionLine = ""
        solutionLetterArray.removeAll(keepingCapacity: true)
                
        if status == .lose {
            numberOfAttempts = 7
            solutions.removeAll(keepingCapacity: true)
        }
        
        // this code runs when the status either inprogress or lose (inprogress: start game or when we go up the level)
        if status != .win {
            if let levelFileUrl = Bundle.main.url(forResource: "Level\(level)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileUrl) {
                    var lines = levelContents.components(separatedBy: "\n")  // here we get an array [String]
                    levelName = lines[0]  // save our level name
                    lines.remove(at: 0)   // as soons as we can we delete our header
                    lines.shuffle()
                    solutionForCompare = lines[0]
                    
                    // putting every letter to Array of solution and preparing questionLine with "?"
                    for letter in lines[0] {
                        solutionLetterArray.append(String(letter))
                        questionLine += "?"
                    }
                    
                    lines.remove(at: 0)       // finally we stay there solution words except our header and current solution we`ve chosen
                    solutions += lines        // get our array global
                    
                }
            }
        } else
        
        // this code runs when we crafted the Word on Level!
        {
            for letter in solutions[0] {
                solutionLetterArray.append(String(letter))
                questionLine += "?"
            }
            solutionForCompare = solutions[0]
            solutions.remove(at: 0)
            status = .inProgress
            
        }
        // then we go back to our main thread
        DispatchQueue.main.async { [weak self] in
            if self?.status == .lose {
                self?.horrorWordUI.text = ""
            }
            self?.levelNameUI.text = self!.levelName
            self?.answerWord.text = questionLine
            self?.answerWord.backgroundColor = .white
            self?.levelNameUI.backgroundColor = .white
            
            // no matter case we update our buttons
            for number in 0..<(self?.letterButtons.count)! {
                self?.letterButtons[number].setTitleColor(.black, for: .normal)
            }
        }
        
    }


}

