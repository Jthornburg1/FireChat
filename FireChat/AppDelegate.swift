//
//  AppDelegate.swift
//  FireChat
//
//  Created by Jon Thornburg on 8/16/16.
//  Copyright © 2016 Jon Thornburg. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notifications = NSNotificationCenter.defaultCenter()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        self.checkIfUserIsLoggedIn()
        notifications.addObserver(self, selector: #selector(checkIfUserIsLoggedIn), name: "registered", object: nil)
        
        return true
    }
    
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            window?.rootViewController = LoginController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: MessagesController())
        }
    }
    
    func handleNotSignedIn() {
        let loginController = LoginController()
        window?.rootViewController = loginController
    }
}
