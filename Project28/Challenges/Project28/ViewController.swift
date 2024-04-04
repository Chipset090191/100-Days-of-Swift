//
//  ViewController.swift
//  Project28
//
//  Created by Михаил Тихомиров on 17.03.2024.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        // this method - adjustForKeyboard will be called when  - keyboardWillHide
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)  // when app is not active anymore
        
        
        // MARK: Challenge 1.1
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lock"), style: .plain, target: self, action: #selector(lockScreen))
        
        // MARK: Challenge 2.1
        KeychainWrapper.standard.set("pass", forKey: "secretPassword")
        
    }
    
    // MARK: Challenge 1.2
    @objc func lockScreen() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder() // stop being active on the screen right now!
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    
    

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        // we chechk whether biometry on the device or not
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // some error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified! Please, try again or click 'Manual' to enter the password", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        // MARK: Challenge 2.2
                        ac.addAction(UIAlertAction(title: "Manual", style: .default, handler: self?.manualEnter))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometrical authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: manualEnter))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
        
        
    }
    func manualEnter(action: UIAlertAction) {
        let ac = UIAlertController(title: "Manual authentication", message: "Enter the password:", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] _ in
            guard let password = ac?.textFields?[0].text else { return }
            
            if password == KeychainWrapper.standard.string(forKey: "secretPassword") {
                self?.unlockSecretMessage()
            } else {
                let EpicFail = UIAlertController(title: "Wrong password!", message: nil, preferredStyle: .alert)
                EpicFail.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(EpicFail, animated: true)
            }
        }))
        present(ac, animated: true)
    }
     

                                    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        
        let keyboardScreenEnd = keyboardValue.cgRectValue // - the size of keyboard relative to the screen
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
            
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset // Margins for our scroll
        
        // finally we let the user scroll within the range that has been selected
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text // put that text inside our text view
        }
    }
    
   @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder() // when you want to programmatically dismiss the keyboard or input view after the user has finished interacting
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    
    
}

