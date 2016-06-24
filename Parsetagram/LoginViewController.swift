//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/19/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var alertController: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!, block: { (user: PFUser?, error: NSError?) in
            if user != nil{
                print("Found User")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            
            else{
                self.alertController = UIAlertController(title: "Invalid Username", message: "Please Try Again", preferredStyle: .Alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                self.alertController.addAction(OKAction)
                
                self.presentViewController(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                
            }
        })
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?)-> Void in
            if success{
                print("User created")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            else {
                print(error?.localizedDescription)
                self.alertController = UIAlertController(title: "Username is Taken", message: "Please Try Again", preferredStyle: .Alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                self.alertController.addAction(OKAction)
                
                self.presentViewController(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }

            }
        }
    }
    
    
    
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
