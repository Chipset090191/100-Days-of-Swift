//
//  DetailViewController.swift
//  LovelyPhotoAlbum
//
//  Created by Михаил Тихомиров on 24.12.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            title = photo.name
            imageView.image = UIImage(contentsOfFile: photo.imagePath)
        }
    }
    
}
