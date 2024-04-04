//
//  ViewController.swift
//  Project18
//
//  Created by Михаил Тихомиров on 14.01.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(1,2,3,4,5)
//        print(1,2,3,4,5, separator: "-")
//        print("Some message", terminator: "")
        
        
//        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure!")         // assert stop executing our code with a fatal error + message
//                                                // useres can never aware of its presence
        
        
        for i in 1..<100 {
            print("Got numer \(i).")
        }
    }


}

