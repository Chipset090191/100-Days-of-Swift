//
//  ViewController.swift
//  Project8
//
//  Created by Михаил Тихомиров on 25.11.2023.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel:UILabel!
    var currentAnswer:UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    var level = 1
    
    override func loadView() {
        // this is a main container for our child Views
        view = UIView()                 // here we`ve created a View Form with a white background
        view.backgroundColor = .white
        
        // layout for score label
        scoreLabel = UILabel()
        
        // scoreLabel
        // to make constraints by hand
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        //cluesLabel
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        // next parameter like a padding in Swoft UI
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) // by using this we stretch our clues label instead of Score
        view.addSubview(cluesLabel)
            
        // answersLabel
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answers"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) // by using this we stretch our answer label instead of Score
        view.addSubview(answersLabel)
        
        // current answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // buttons
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        // PS. layoutMarginsGuide - is a container inside a safeAreaLayoutGuide
        
        // to activate Anchor for our elements
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            // more constraints to be added here!
        ])
        
        // for every button
        let width = 150
        let height = 80
        
        // creating buttons here
            for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.backgroundColor = .green
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
                // that`s a frame base for buttons
                let frame = CGRect(x: column * width, y: row * height, width: width - 5, height: height - 5)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .green
//        buttonsView.backgroundColor = .green
//        currentAnswer.backgroundColor = .red
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // MARK: Challenge 2.1 from Project 9
        // running our code on a background thread
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
    }
    
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)   // here we add our button into an array of buttons
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        // then we get position in array of solutions if our answer is correct
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n") // here we get an optional array of [String]?
            
            splitAnswers?[solutionPosition] = answerText
            
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            
            if score.isMultiple(of: 7) {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let`s go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        
        solutions.removeAll(keepingCapacity: true)  // we keep capacity this time so we would use it again in the future
        
        // MARK: Challenge 2.2 from Project 9
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
        // we show every button again with a new bits
        for button in letterButtons {
            button.isHidden = false
        }
        
        
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    @objc func loadLevel() {
         var clueString = ""
         var solutionsString = ""
         var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String (contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n") // here we created an array with [String]
                lines.shuffle()
//                print (lines[0])
                
                // at this point our array looks like tuple (x - index of line in array,
                // and y - the value
                for (index, line) in lines.enumerated() {
                    // then we create one more array dividing value by two values from the prev
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0] // HA|UNT|ED
                    let clue = parts[1]   // Ghosts in residence
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")   // then we get - HAUNTED
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
                
            }
        }
        // MARK: Challenge 2.3 from Project 9
        DispatchQueue.main.async { [weak self] in
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self?.letterButtons.shuffle()
            
            if self?.letterButtons.count == letterBits.count {
                for i in 0..<self!.letterButtons.count {
                    self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
        
        
    }


}

