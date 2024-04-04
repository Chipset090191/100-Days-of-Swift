//
//  ViewController.swift
//  Project10
//
//  Created by Михаил Тихомиров on 11.12.2023.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate protocol - tells us when the user chose an image or cancel the picker
    // UINavigationControllerDelegate protocol - is used when the user selected the image and that is being to return us
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell

        let person = people[indexPath.item]

        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        // MARK: Challenge 2.1 (only is gonna work on a real device. Make sure that in info plist - Camera - Usage Description added)
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            picker.sourceType = .camera
//        }
        
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        


        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView?.reloadData()

        dismiss(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = people[indexPath.item]
        
        
        // MARK: Challenge 1.1
        
        let ac = UIAlertController(title: "Edit Photo", message: "Do you want to rename or delete this person?", preferredStyle: .alert)
            
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in self?.renamePerson(indexPath: indexPath)}))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in self?.deletePerson(collectionView, indexPath: indexPath)}))

        
        present(ac, animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: Challenge 1.2
    @objc func renamePerson(indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    // MARK: Challenge 1.3 (deleting smoothly)
    @objc func deletePerson(_ collectionView: UICollectionView, indexPath: IndexPath) {
        people.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    
    
    

}

