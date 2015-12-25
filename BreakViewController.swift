//
//  BreakViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/23/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class BreakViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var FBLoginView: UIView!
    @IBOutlet var sameUserButton: UIButton!

    let userDefaults = NSUserDefaults.standardUserDefaults()

    var parentVC: CenterViewController!

    var newRank: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self

        if let name = self.userDefaults.stringForKey("username") {
            self.nameTextField.text = name
        } else {
            self.nameTextField.text = ""
        }

        // Add Facebook login button
        let loginView = FBSDKLoginButton()
            loginView.delegate = self
            loginView.readPermissions = ["public_profile"]
            loginView.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width - 80, 50 )
        self.FBLoginView.addSubview( loginView )
    }

    @IBAction func register(sender: AnyObject) {

        // Get the name
        var name = self.nameTextField.text ?? ""
        if name == "" {
            name = ">__<"
        } else {
            self.userDefaults.setValue( name, forKey: "username" )
        }

        self.sendUpdateRequest( name )

    }

    @IBAction func registerAsSameUser(sender: AnyObject) {
        let name = self.userDefaults.stringForKey("fb_name")!
        let fbid = self.userDefaults.stringForKey("fb_id")!

        self.sendUpdateRequest(name, fbid: fbid)
    }

    func updateView() {

        self.timeLabel.text = parentVC.currentSecond.displayText()

        if FBSDKAccessToken.currentAccessToken() == nil {
            self.sameUserButton.hidden = true
        } else {
            self.sameUserButton.hidden = false
            if let name = self.userDefaults.stringForKey("fb_name") {
                self.sameUserButton.setTitle( "Yes, I'm \(name).", forState: .Normal)
            }
        }

    }

    func sendUpdateRequest( username: String, fbid: String = "" ) {

        let httpRequest = NSMutableURLRequest(URL: NSURL( string: ServerTalker.update )!)
            httpRequest.HTTPMethod = "POST"

        var postString = "name=\(username)&time=\(parentVC.currentSecond.displayText())&rank=\(self.newRank)"
        if fbid != "" {
            postString += "&fbid=\(fbid)"
        }
        httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let updateData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest )
        updateData.resume()

        // Present RankTableViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rankViewController = storyboard.instantiateViewControllerWithIdentifier("RankTable") as! RankTableViewController
            rankViewController.newDataRow = self.newRank
            rankViewController.forceUpdate = true
        let navigationController = UINavigationController(rootViewController: rankViewController)

        parentVC.breakViewContainer.hidden = true
        self.presentViewController(navigationController, animated: true, completion: nil)

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }



    // *************
    // Facebook login

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if error != nil {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // Navigate to other view

            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if error == nil {
                    let FBID = result.objectForKey("id") as! String
                    let name = result.objectForKey("name") as! String

                    self.userDefaults.setValue( FBID, forKey: "fb_id" )
                    self.userDefaults.setValue( name, forKey: "fb_name" )

                    self.sendUpdateRequest( name, fbid: FBID )
                }

            }) // --- graphRequest
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.sameUserButton.hidden = true

        self.userDefaults.removeObjectForKey("fb_id")
        self.userDefaults.removeObjectForKey("fb_name")
    }

}
