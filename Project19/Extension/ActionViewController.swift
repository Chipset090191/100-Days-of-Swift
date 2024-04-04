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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        // this notification posts when keyboard will be hide
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        // this notification posts when keyboard`s frame is changed
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    // when we`ve got it than we push to the main thread
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        
                    }
                    
                    
                    
                }
            }
        }
    }

    @IBAction func done() {
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

}
