//
//  ViewController.swift
//  Project15
//
//  Created by Михаил Тихомиров on 05.01.2024.
//

import UIKit

extension UIView {
    
    func bounceOut(duration:TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

class ViewController: UIViewController {
    
    var imageView:UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func Tapped(_ sender: UIButton) {
        
        sender.isHidden = true
        
        self.imageView.bounceOut(duration: 4)
        
    }
    
}

