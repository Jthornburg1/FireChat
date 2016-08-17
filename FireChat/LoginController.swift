//
//  LoginController.swift
//  FireChat
//
//  Created by Jon Thornburg on 8/16/16.
//  Copyright © 2016 Jon Thornburg. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class LoginController: UIViewController {
    
    let noifications = NSNotificationCenter.defaultCenter()
    let fireCalls = FirebaseCalls()
    let picker = UIImagePickerController()
    var image: UIImage?
    var breakToGetImage: Bool?
    var photoChosen = false
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.secureTextEntry = true
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "game")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.userInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.insertSegmentWithTitle("Login", atIndex: 0, animated: true)
        segmentedControl.insertSegmentWithTitle("Register", atIndex: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        // add view for login input
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(segmentedControl)
        
        setUpInputsContainerView()
        setUpLoginButtonConstraints()
        setUpImageView()
        setUpSegmentedController()
    }
    
    func handleLoginRegisterChange() {
        let title = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        // change height of input view container
        inputsContainerHeightConstraint?.constant = segmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        // change height of name textField and separator to 0
        nameTextfieldHeightAnchor?.active = false
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextfieldHeightAnchor?.active = true
        nameSeparatorViewHeightConstraint?.active = false
        nameSeparatorViewHeightConstraint = nameSeparatorView.heightAnchor.constraintEqualToConstant(segmentedControl.selectedSegmentIndex == 0 ? 0 : 1)
        nameSeparatorViewHeightConstraint?.active = true
        // change heights of passwordTextF and emailTextF
        passwordTextfieldHeightConstraint?.active = false
        passwordTextfieldHeightConstraint = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextfieldHeightConstraint?.active = true
        
        emailTextfieldHeightConstraint?.active = false
        emailTextfieldHeightConstraint = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextfieldHeightConstraint?.active = true
        
    }
    
    var inputsContainerHeightConstraint: NSLayoutConstraint?
    var nameTextfieldHeightAnchor: NSLayoutConstraint?
    var nameSeparatorViewHeightConstraint: NSLayoutConstraint?
    var emailTextfieldHeightConstraint: NSLayoutConstraint?
    var passwordTextfieldHeightConstraint: NSLayoutConstraint?
    
    //constraints functions
    func setUpInputsContainerView() {
        // need x, y, height, and width constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputsContainerHeightConstraint = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputsContainerHeightConstraint?.active = true
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        
        // need x, y, height, and width constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor,multiplier: 1/3)
        nameTextfieldHeightAnchor!.active = true
        
        // need x, y, height, and width constraints
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -48).active = true
        nameSeparatorViewHeightConstraint = nameSeparatorView.heightAnchor.constraintEqualToConstant(1)
        nameSeparatorViewHeightConstraint!.active = true
        
        // need x, y, height, and width constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(nameSeparatorView.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextfieldHeightConstraint = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextfieldHeightConstraint!.active = true
        
        // need x, y, height, and width constraints
        passwordSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordSeparatorView.topAnchor.constraintEqualToAnchor(passwordTextField.bottomAnchor).active = true
        passwordSeparatorView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -48).active = true
        passwordSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // need x, y, height, and width constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor,constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(passwordSeparatorView.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(passwordTextField.widthAnchor).active = true
        emailTextfieldHeightConstraint = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextfieldHeightConstraint!.active = true
    }
    
    func setUpLoginButtonConstraints() {
        // need x, y, height, and width constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func setUpImageView() {
        
        // need x, y, height, and width constraints
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(view.topAnchor,constant: 60).active = true
        profileImageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -120).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -60).active = true
        
    }
    
    func setUpSegmentedController() {
        segmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        segmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        segmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -10).active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else {
            print("Form is not valid.")
            return
        }
        fireCalls.authenticate(email, password: password) { (success, uid) in
            if success {
                var imag: UIImage?
                
                if self.photoChosen == true {
                    if let img = self.profileImageView.image {
                        imag = img
                        self.fireCalls.storeImageToFirebase(imag!, pathString: uid!, completion: { (success, urlString) in
                            if success {
                                let str = String(urlString!)
                                self.fireCalls.addUserToDatabase(uid!, name: name, password: password, email: email, image: str, completion: { (success, error) in
                                    if success {
                                        print("success")
                                        let notif = NSNotification(name: "registered", object: nil)
                                        self.noifications.postNotification(notif)
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    } else {
                                        self.showAlert("Failed to save", message: "Please re-enter the data")
                                        self.clearFields()
                                    }
                                })
                            }
                        })
                    }
                } else {
                    self.fireCalls.addUserToDatabase(uid!, name: name, password: password, email: email, image: "", completion: { (success, error) in
                        if success {
                            print("success")
                            let notif = NSNotification(name: "registered", object: nil)
                            self.noifications.postNotification(notif)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            self.showAlert("Failed to save", message: "Please re-enter the data")
                            self.clearFields()
                        }
                    })

                }
            } else {
                self.showAlert("Failure.", message: "You'll never cut it on this app because you produced an error!")
            }
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, password = passwordTextField.text else {
            print("Form is not valid.")
            return
        }
        fireCalls.firebaseLogin(email, password: password) { (success) in
            if success {
                let notif = NSNotification(name: "registered", object: nil)
                self.noifications.postNotification(notif)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.showAlert("Failure.", message: "You'll never cut it on this app because you produced an error!")
                self.clearFields()
            }
        }
    }
    
    func handleLoginRegister() {
        if segmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.view.tintColor = UIColor.redColor()
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.nameTextField.text = ""
    }
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}