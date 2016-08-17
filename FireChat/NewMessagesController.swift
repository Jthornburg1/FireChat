//
//  NewMessagesController.swift
//  FireChat
//
//  Created by Jon Thornburg on 8/16/16.
//  Copyright © 2016 Jon Thornburg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    let fireCalls = FirebaseCalls()
    
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handelCancel))
        self.fetchUzers()
    }
    
    func handelCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = self.users[indexPath.row].name
        cell.detailTextLabel?.text = self.users[indexPath.row].email
        return cell
    }
    
    func fetchUzers() {
        fireCalls.getUsers { (users) in
            if let usrs = users {
                self.users = usrs
                self.tableView.reloadData()
            }
        }
    }
}