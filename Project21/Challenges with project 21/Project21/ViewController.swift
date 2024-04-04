//
//  ViewController.swift
//  Project21
//
//  Created by Михаил Тихомиров on 02.02.2024.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = 
        UIBarButtonItem(title: "Register",
                        style: .plain,
                        target: self,
                        action: #selector(registserLocal))
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "Schedule",
                        style: .plain,
                        target: self,
                        action: #selector(scheduleLocal))
        
    }
   
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yeap")
            } else {
                print("Nope")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current() // get access to our current version of user notification center
                                                        // which is what lets us post messages to the home screen
         
        center.removeAllPendingNotificationRequests() // that`s better do before a new req
         
         // the content to be shown
         let content = UNMutableNotificationContent()
         content.title = "Late wake up call"
         content.body = "The early bird catches the worm, but the second mouse gets the cheese."
         content.categoryIdentifier = "alarm"
         content.userInfo = ["customData":"fizzbuzz"]
         content.sound = .default
         
        
         // when the content to be shown
         var dateComponents = DateComponents()
         dateComponents.hour = 10
         dateComponents.minute = 30
        
//         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // that`s for the test
         
        
         // then we form request
         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
         center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // MARK: Challenge 2.1
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let Remind_me = UNNotificationAction(identifier: "Remind_me", title: "Remind me later", options: .foreground)
        // .foreground means when the button is tapped we must launch the app immediately
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,Remind_me], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print ("Custom data received: \(customData)")
            
            // MARK: Challenge 2.2
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print ("Default identifier")
            case "show":
                let ac  = UIAlertController(title: "Showed info", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                present(ac, animated: true)
            case "Remind_me":
                let ac  = UIAlertController(title: "I will let you know", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
                remindMeLater()
            default:
                break
            }
        }
        
        completionHandler()
        
    }
    // MARK: Challenge 2.3
    func remindMeLater() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Late wakeup call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        let requests = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(requests)
    }


}

