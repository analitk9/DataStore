//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 7/25/22.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.sound, .badge, .provisional]
    
    func registeForLatestUpdatesIfPossible(){
        
    }
}
