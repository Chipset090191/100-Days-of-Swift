//
//  ViewController.swift
//  Memes
//
//  Created by Михаил Тихомиров on 14.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var onTop: String?
    var onBottom:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add_image))
        
    }
    
    @IBAction func onTop(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let ac = UIAlertController(title: "Write your text below:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let text = ac.textFields![0].text else { return }
            self?.onTop = text
            self?.renderImage(image)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submit)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    @IBAction func onBottom(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let ac = UIAlertController(title: "Write your text below:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let text = ac.textFields![0].text else { return }
            self?.onBottom = text
            self?.renderImage(image)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submit)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    @objc func add_image() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
        
    }
    
    
    func renderImage(_ image: UIImage) {
        let size = image.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { ctx in
            let picture = image
            picture.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray
            shadow.shadowBlurRadius = 4
            
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 90),
                .foregroundColor: UIColor.white,
                .shadow: shadow,
                .paragraphStyle: paragraphStyle
            ]
            
            if let top = self.onTop {
                let attributedString = NSAttributedString(string: top.uppercased(), attributes: attrs)
                attributedString.draw(with: CGRect(x: 0, y: 5, width: size.width, height: size.height), options: .usesLineFragmentOrigin ,context: nil)
            }
            
            
            if let bottom = self.onBottom {
                let attributedString = NSAttributedString(string: bottom.uppercased(), attributes: attrs)
                attributedString.draw(with: CGRect(x: 0, y: size.height - 100, width: size.width, height: size.height), options: .usesLineFragmentOrigin ,context: nil)
            }
                
            
        }
        
        self.imageView.image = renderedImage
        
    }

}



// MARK: Our exstentions for ViewController
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

