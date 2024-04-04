//
//  DetailViewController.swift
//  Project1
//
//  Created by Михаил Тихомиров on 01.11.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Challenge 2.1 from project 18
        assert(selectedImage != nil, "failure!")
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hidesBarsOnTap = false
    }
    
}
