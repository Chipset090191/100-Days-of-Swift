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
    // MARK: Challenge 3.2
    var Collection:Int?
    var NumberOfCollection:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Challenge 3.3
        title = "PICTURE \(selectedImage?.replacingOccurrences(of: ".jpg", with: "") ?? "Unknown") \(NumberOfCollection ?? 0) of \(Collection ?? 0)"
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
