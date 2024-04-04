//
//  ViewController.swift
//  Project5
//
//  Created by Михаил Тихомиров on 14.11.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        // MARK: Challenge3.1
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(startGame))
        
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n") // "\n" - that`s a magic character for line break
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // we used weak because we wanna be sure that our closure doesn`t capture our links (self and ac) strongly to avoid memory leak
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in // we do not need the action of UIAlertAction here!we don`t need body
            guard let answer = ac?.textFields?[0].text else { return } // ac? - is a weak reference now and might not exist in the future and could be nil
            self?.submit(answer)
            
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    
    func submit(_ answer:String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle:String
        let errorMessage: String
        
        // MARK: Challenge 1.2
        if !isaTitle(word: lowerAnswer){
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(lowerAnswer, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)     // easier way to add some data not reloading the View itself
                        
                        return // if the word we`ve tapped is ok we just return from that func
                    } else {
                        errorTitle = "Word not recognized"
                        errorMessage = "You can`t just make them up, you know!"
                          // MARK: Challenge 2.1 (and going on down showErrorMessage())
                          showErrorMessage(error_Message: errorMessage, error_Title: errorTitle)
                    }
                } else {
                    errorTitle = "Word already used"
                    errorMessage = "Be more original!"
                    showErrorMessage(error_Message: errorMessage, error_Title: errorTitle)
                }
            } else {
                errorTitle = "Word not possible"
                errorMessage = "You can`t spell that word from \(title!.lowercased())."
                showErrorMessage(error_Message: errorMessage, error_Title: errorTitle)
            }
        } else {
            errorTitle = "Word is the same"
            errorMessage = "You can`t use the title`s word."
            showErrorMessage(error_Message: errorMessage, error_Title: errorTitle)
        }
        
            
    }
    
    // MARK: Challenge 1.3
    func isaTitle(word:String) -> Bool {
        word == title?.lowercased()
    }
    
    // MARK: Challenge 2.2
    func showErrorMessage(error_Message: String, error_Title:String) {
                let ac = UIAlertController(title: error_Title, message: error_Message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                
                present(ac, animated: true)
    }

    
    // we check here if our world we`ve previously tapped might be in the title, if so we just return true
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    // we check whether the word we`ve tried or not
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    // we check it according to the vocab
    func isReal(word: String) -> Bool {
        // MARK: Challenge 1.1
        if word.count < 3 { return false }
        
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count) // we tell that the range starts from 0 and got through the whole range of the word
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en") // then we check the word
        return misspelledRange.location == NSNotFound // if there`s no location for misspelled word we return true
        
    }
}

