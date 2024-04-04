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
//       guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//                print("No image found")
//           return
//       }
       
       let image = renderImage()
       

    
       let vc = UIActivityViewController(activityItems: [image, selectedImage?.replacingOccurrences(of: ".jpg", with: "") as Any], applicationActivities: [])
       vc.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
       present(vc, animated: true)
    }
    
    // MARK: Challenge 3.1 from project27 ( this code was created by Thomas Kellough on 7/16/19 because I was lazy to do that)). Just adapt to this project)
    func renderImage() -> UIImage {
        if let imageName = selectedImage {
            if let size = imageView.image?.size {
                
                let renderer = UIGraphicsImageRenderer(size: size)
                
                let image = renderer.image { ctx in
                    let photo = UIImage(named: imageName)
                    photo?.draw(at: CGPoint(x: 0, y: 0))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 48),
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let string = "From Storm Viewer"
                    let attributedString = NSAttributedString(string: string, attributes: attrs)
                    
                    attributedString.draw(with: CGRect(x: size.width / 6, y: size.height / 2, width: size.width, height: size.height), options: .usesLineFragmentOrigin, context: nil)
                    
                }
                return image
            }
        }
        fatalError("Image could not render correctly")
    }
    
}
