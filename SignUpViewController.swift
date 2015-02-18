//
//  SignUpViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var signupActive = true
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String,error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
         self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var alreadyRegistered: UILabel!
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var signupToggleButton: UIButton!
    
    @IBAction func toggleSignup(sender: AnyObject) {
        
        if signupActive == true {
            
            signupActive = false
            
            signupLabel.text = "Use the form below to log in"
            
            signupButton.setTitle("Log In!", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Not Registered?"
            
            signupToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        } else {
            
            signupActive = true
            
            signupLabel.text = "Use the form below to sign up"
            
            signupButton.setTitle("Sign Up!", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Already Registered?"
            
            signupToggleButton.setTitle("Log In", forState: UIControlState.Normal)
            
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "Please enter a username and password."
        }
        
        if error != "" {
            
            displayAlert("Error In Form", error:error)
        }
        
        else {
            
            if signupActive == true {
                
                activityIndicator = UIActivityIndicatorView (frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if signupError == nil {
                        //Hooray let them use the app now.
                        
                        println("Signed Up")
                        
                        self.performSegueWithIdentifier("signupseg", sender: self)
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        }
                        else {
                            "Please try again later."
                        }
                        //needs self because its inside a closure
                        self.displayAlert("Could not sign up!", error: error)
                    }
                }
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
                    (user:PFUser!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if signupError == nil {
                        //Do stuff after succesful login.
                        println("Logged In")
                        
                        self.performSegueWithIdentifier("signupseg", sender: self)
                        
                    } else {
                        //explain error
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        }
                        
                        else {
                            "Please try again later."
                        }
                        //needs self because its inside a closure
                        self.displayAlert("Could not log in!", error: error)
                    }
                }
            }
        }
        
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gets/saves details of current user using core data
        println(PFUser.currentUser())
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("signupseg", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
}
