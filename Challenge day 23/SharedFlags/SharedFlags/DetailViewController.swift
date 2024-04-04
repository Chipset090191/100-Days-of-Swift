//
//  DetailViewController.swift
//  SharedFlags
//
//  Created by Михаил Тихомиров on 07.11.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // when we push our DetailViewController we get selectedImage from there
    var selectedImage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // appearance of title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ShareFlag))
        
        
        if let imageToLoad = selectedImage {
            title = imageToLoad.uppercased()
            imageView.image = UIImage(named: imageToLoad)
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
        }

    }
    
    @objc func ShareFlag() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print ("No image found!")
            return
        }
        
        // combined data in Any aarray collection
        let joinedData:[Any] = [imageData, selectedImage!.uppercased()]
        
        //
        let vc = UIActivityViewController(activityItems: joinedData, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
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
