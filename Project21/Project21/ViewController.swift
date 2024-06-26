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
                        action: #selector(registerLocal))
        
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
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        // .foreground means when the button is tapped we must launch the app immediately
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print ("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print ("Default identifier")
            case "show":
                print ("Show more information...")
            default:
                break
            }
        }
        
        completionHandler()
        
    }


}

