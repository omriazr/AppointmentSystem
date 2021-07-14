//
//  NotificationLogic.swift
//  AppointmentSystem
//
//  Created by omri azaria on 14/07/2021.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import UserNotifications

class NotificationLogic: ObservableObject {
    let uuidString = UUID().uuidString
    
    func askPermissions(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granred, error) in
        }
    }
    
    func cancelNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuidString])
    }
    
    func setUpNotification(date:Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "AppointmentSystem"
        content.body = "Your appointment starts now, Please enter the doctor's room"
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let requset = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(requset) { (error) in
        }
    }
}
