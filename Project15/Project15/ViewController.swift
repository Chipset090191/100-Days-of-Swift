//
//  ViewController.swift
//  Project15
//
//  Created by Михаил Тихомиров on 05.01.2024.
//

import UIKit

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
        
        
        
//        UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2) // Here we increase our figure two times
//            case 1:
//                self.imageView.transform = .identity // here we set the default size of our figure
//            case 2:
//                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256) // move up to the left
//            case 3:
//                self.imageView.transform = .identity // here we set the default size of our figure
//            case 4:
//                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
//            case 5:
//                self.imageView.transform = .identity // here we set the default size of our figure
//            case 6:
//                self.imageView.alpha = 0.1
//                self.imageView.backgroundColor = .green
//            case 7:
//                self.imageView.alpha = 1
//                self.imageView.backgroundColor = .clear
//            default:
//                break
            }
        } completion: { finished in
            sender.isHidden = false
        }
    
        
//        currentAnimation += 1
//        
//        if currentAnimation > 7 {
//            currentAnimation = 0
//        }
        
    }
    
}

