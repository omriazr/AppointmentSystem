//
//  ViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 08/07/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    var notificationLogic = NotificationLogic()
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        signUpButton.backgroundColor = UIColor.systemTeal
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.tintColor = UIColor.white
        
        logInButton.backgroundColor = UIColor.systemBlue
        logInButton.layer.cornerRadius = 25.0
        logInButton.tintColor = UIColor.white
        
        notificationLogic.askPermissions()
    }


}

