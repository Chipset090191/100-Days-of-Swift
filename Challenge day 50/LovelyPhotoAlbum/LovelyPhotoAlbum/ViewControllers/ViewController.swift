//
//  ViewController.swift
//  LovelyPhotoAlbum
//
//  Created by Михаил Тихомиров on 24.12.2023.
//

import UIKit

class ViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My lovely photo album💕"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        
        if let data = UserDefaults.standard.data(forKey: "photos") {
            if let decoded = try? JSONDecoder().decode([Photo].self, from: data) {
                photos = decoded
            }
        }
        
        

    }
    
    // IMPORTANT STEP !!! you must use HeightForRowAt for your customed cell in table View Your Picture will get stretched in spite of the constraints you assigned to ImageView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCustomedCell", for: indexPath)
        
    
        if let cell = cell as? PhotoCustomedCell {
            cell.CustomedName.text = photo.name
            
            
            cell.CustomedImageView.image = UIImage(contentsOfFile: photo.imagePath)

            cell.CustomedImageView.layer.borderColor = UIColor.gray.cgColor
            cell.CustomedImageView.layer.borderWidth = 1
            cell.CustomedImageView.layer.cornerRadius = 9
            
        }
        
        return cell
    }
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Bundle.main.documentsDirectory.appendingPathComponent(imageName)  // this func is placed on AccessData
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        showCaptionAlert(forImage: imageName)
        

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            
            vc.photo = photo
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    func showCaptionAlert(forImage imageName: String) {
        let ac = UIAlertController(title: "What name do you want to give it?", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac]_ in
            guard let newName = ac?.textFields?[0].text else { return }
            let newPhoto = Photo(name: newName, image: imageName)
            self?.photos.append(newPhoto)
            self?.saveToUserDefaults()
        }))
        
        present(ac, animated: true)
    }
    
    func saveToUserDefaults() {
        DispatchQueue.global().async{ [weak self] in
            if let encoded = try? JSONEncoder().encode(self?.photos) {
                UserDefaults.standard.set(encoded, forKey: "photos")
            } else {
                print("Failed to save photo data")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
}

