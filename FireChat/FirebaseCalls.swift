//
//  FirebaseCalls.swift
//  FireChat
//
//  Created by Jon Thornburg on 8/16/16.
//  Copyright © 2016 Jon Thornburg. All rights reserved.
//

import Foundation
import Firebase

protocol Authentication {
    func authenticate(email: String, password: String, completion: (success: Bool, uid: String?) -> Void)
    func addUserToDatabase(uid: String, name: String, password: String, email: String, image: String?, completion: (success: Bool, error: NSError?) -> Void)
    func getCurrentUser(completion: (dict: [String : AnyObject]?) -> Void)
    func firebaseLogin(email: String, password: String, completion: (success: Bool) -> Void)
}

protocol GetData {
    func getUsers(completion: (users: [User]?) -> Void)
}

struct FirebaseCalls: Authentication, GetData {
    
    let ref = FIRDatabase.database().reference
    
     func authenticate(email: String, password: String, completion: (success: Bool, uid: String?) -> Void) {
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    print(error?.localizedDescription)
                    completion(success: false, uid: nil)
                })
            } else {
                guard let uid = user?.uid else {
                    return
                }
                print("Registered!!!")
                self.ref().updateChildValues(["SomeValue" : 123123])
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(success: true, uid: uid)
                })
            }
        })
        
    }
    
    func addUserToDatabase(uid: String, name: String, password: String, email: String, image: String?, completion: (success: Bool, error: NSError?) -> Void) {
        var imUrl: String?
        if let urlStr = image {
            imUrl = urlStr
        } else {
            imUrl = ""
        }
        let values = ["name" : name, "password" : password, "email" : email, "imageUrlString" : imUrl!]
        self.ref().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err?.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(success: false, error: err)
                })
            } else {
                print("User saved to database.")
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(success: true, error: nil)
                })
            }
        })
    }
    
    func getCurrentUser(completion: (dict: [String : AnyObject]?) -> Void) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                completion(dict: nil)
            })
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeEventType(.Value, withBlock: { (snapshot) in
                print(snapshot)
                let dict = snapshot.value as! [String : AnyObject]
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(dict: dict)
                })
            })
        }
    }
    
    func firebaseLogin(email: String, password: String, completion: (success: Bool) -> Void){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(success: false)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completion(success: true)
                })
            }
        })
    }
    
    func getUsers(completion: (users: [User]?) -> Void) {
        var users = [User]()
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                let user = User()
                user.setValuesForKeysWithDictionary(dict)
                users.append(user)
                print("User # \(users.count) found.")
            }
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                completion(users: users)
            })
        })
    }
    
    // Storage
    func storeImageToFirebase(image: UIImage, pathString: String, completion: (success: Bool, urlString: NSURL?) -> Void) {
        let storageRef = FIRStorage.storage().reference().child(pathString)
        let smallIm = image.resizeWithPercentage(0.2)
        if let uploadData = UIImagePNGRepresentation(smallIm!) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        completion(success: false, urlString: nil)
                    })
                } else {
                    let str = metadata?.downloadURL()
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        completion(success: true, urlString: str)
                    })
                }
            })
        }
    }
}




