//
//  ActionViewController.swift
//  Extension
//
//  Created by Михаил Тихомиров on 22.01.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    
    @IBOutlet var script: UITextView!
    
    // this are two things is being passed id from Safari
    var pageTitle = ""
    var pageURL = ""
    //MARK: Challenge 2.1
    var savedUrlScripts: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Challenge 1.1
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseExample))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        // this notification posts when keyboard will be hide
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        // this notification posts when keyboard`s frame is changed
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        // here we look at our extensions (this actually as an array of extensions)
        //then we get our extension
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // firstly we get data from JS and to get it readable we use a specific key NSExtensionJavaScriptPreprocessingResultsKey
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    // here we get result from pre=processing file JS and make the dict form that
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    
                    
                    // when we`ve got it than we push to the main thread
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        //MARK: Challenge 2.2
                        self?.getSavedFromUserDefaults()
                    }
                }
            }
        }
    }
    
    //MARK: Challenge 2.3
    func getSavedFromUserDefaults() {
        savedUrlScripts = UserDefaults.standard.dictionary(forKey: "savedUrlScripts") as? [String:String] ?? [:]
        if let url = URL(string: pageURL) {
            if let host = url.host {
                script.text = savedUrlScripts[host]
            }
        }
    }
    //MARK: Challenge 2.4
    func setScriptsForUrl() {
        if let url = URL(string: pageURL) {
            if let host = url.host {
                savedUrlScripts.updateValue(script.text, forKey: host)
            }
        }
        
        UserDefaults.standard.set(savedUrlScripts, forKey: "savedUrlScripts")
    }
    
    @IBAction func done() {
        DispatchQueue.global(qos: .background).async {
            self.setScriptsForUrl()
        }
        
        // here reverse process where we push back to safary our request trough extension with finalize func
         let item = NSExtensionItem()
         let argument:NSDictionary = ["customJavaScript": script.text]
         let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
         let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
         item.attachments = [customJavaScript]
         extensionContext?.completeRequest(returningItems: [item])
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        // NSValue keyboard will tell us the size of the keyboard we can now read
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue // the size of keyboard
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)   // the corrected size of the keyboard in our rotated screen space
        
        // next we check we either hiding or not
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            // if we are not in hide so if we`re in did change frame
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0) //here - view.safeAreaInsets.bottom means that that we want to compensate safe area to look good (only for phones ten`s series)
        }
        
        // how much murgins apply to that little scroll bar on the right edge of text views when they scroll
        script.scrollIndicatorInsets = script.contentInset // so ii will match always the size of our text view
        
        
        
        let selectedRange = script.selectedRange
        
        script.scrollRangeToVisible(selectedRange) // if you type and gets obscured by keyboard it will be scroll down to Visible
    
    }
    //MARK: Challenge 1.2
    @objc func chooseExample() {
        let ac = UIAlertController(title: "Examples of scripts:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Title", style: .default, handler: setText))
        ac.addAction(UIAlertAction(title: "URL", style: .default, handler: setText))
        
        present(ac, animated: true)
    }
    
    //MARK: Challenge 1.3
    func setText(action:UIAlertAction) {
        guard let actionTitle = action.title else { return }
        
        switch actionTitle {
        case "Title":
            script.text = "alert(document.title)"
        case "URL":
            script.text = "alert(document.URL)"
        default: break
        }
        
    }

}
