//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 7/25/22.
//

import Foundation
import UserNotifications

protocol LocalNotificationsServiceDelegate{
    func notificationPressAccept()
}

class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert,.sound, .badge, .provisional]
    let userCategory = "updates"
    var delegate: LocalNotificationsServiceDelegate?
    
    
    func registeForLatestUpdatesIfPossible(){
        notificationCenter.requestAuthorization(options: [options]) { granted, error in
            if !granted {
              
            }
        }
       
    }
    
     func registerUpdatesCategory(){
       
         let acceptAction = UNNotificationAction(identifier: "Accept", title: "Accept", options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "Decline", title: "Decline", options: [.destructive])
        let category = UNNotificationCategory(identifier: userCategory,
                                              actions: [acceptAction, declineAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
     func registryNotification(){
        notificationCenter.delegate = self
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 19
        dateComponents.minute = 0
        //let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Проверь ленту новостей"
        content.body = "Посмотрите последние обновления"
        content.categoryIdentifier = userCategory
       content.sound = .default
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        notificationCenter.add(request)
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Decline":
            print("Decline")
            notificationCenter.removeAllPendingNotificationRequests()
        case "Accept":
            guard let delegate = delegate else {
                return
            }

            delegate.notificationPressAccept()
            print("Accept")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound,.banner])
    }
}


