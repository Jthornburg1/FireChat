//
//  ViewController.swift
//  FireChat
//
//  Created by Jon Thornburg on 8/16/16.
//  Copyright © 2016 Jon Thornburg. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let loginController = LoginController()
    let fireCalls = FirebaseCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckIfUserIsLoggedIn()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        //getUser()
        let Quill = UIImage(named: "Quill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Quill!, style: .Plain, target: self, action: #selector(handleNewMessage))
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.getUser()
    }
    
    func CheckIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(#selector(handleLogout),withObject: nil, afterDelay: 0)
        }
    }
    
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func getUser() {
        fireCalls.getCurrentUser { (dict) in
            if dict == nil {
                self.handleLogout()
            } else {
                self.navigationItem.title = dict!["name"] as? String
            }
        }
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        presentViewController(navController, animated: true, completion: nil)
    }
}

