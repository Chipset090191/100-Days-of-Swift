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
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        // systemItem .action shows the action button (share button),
        // action: - describes what particular method will be run
        // target: - says place of declaration of our method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
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
    
   @objc func shareTapped() {
       guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
           return
       }
       

    
       let vc = UIActivityViewController(activityItems: [image], applicationActivities:[] )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem  // that`s for Ipad
        present(vc, animated: true)
    }
    
}
