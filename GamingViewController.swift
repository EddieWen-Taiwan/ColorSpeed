//
//  ViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 11/16/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON
import FBSDKLoginKit

class GamingViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet var breakView: SpringView!

    // in break view
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var newTimeRecordLabel: UILabel!
    @IBOutlet var FBLoginView: UIView!
    @IBOutlet var sameUserButton: UIButton!

    let userP = NSUserDefaults.standardUserDefaults()

    var newRank: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Add gesture
//        let restartGesture = UITapGestureRecognizer(target: self, action: "restartGame")
//        self.restartButton.addGestureRecognizer( restartGesture )

        // Preenter user name
        if let username = self.userP.stringForKey("username") {
            self.nameTextField.text = username
        }

        self.nameTextField.delegate = self
        // Add Facebook login button
        self.view.layoutIfNeeded()

        let loginView = FBSDKLoginButton()
        self.FBLoginView.addSubview( loginView )
        loginView.frame = CGRectMake( 0, 0, self.FBLoginView.frame.width, self.FBLoginView.frame.height )
        loginView.readPermissions = [ "public_profile" ]
        loginView.delegate = self
    }











    // *************
    // Ending View




    // *************
    // Break View

    func sendUpdateRequest( username: String, fbid: String = "" ) {

//        let httpRequest = NSMutableURLRequest(URL: NSURL( string: ServerTalker.update )!)
//        httpRequest.HTTPMethod = "POST"
//
//        var postString = "name=\(username)&time=\(self.currentSecond.displayText())&rank=\(self.newRank)"
//        if fbid != "" {
//            postString += "&fbid=\(fbid)"
//        }
//        httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//
//        let updateData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest )
//        updateData.resume()
//
//        // Hide this BreakView
//        self.breakView.hidden = true
//
//        // Present RankTableViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rankViewController = storyboard.instantiateViewControllerWithIdentifier("RankTable") as! RankTableViewController
//        rankViewController.newDataRow = self.newRank
//        rankViewController.forceUpdate = true
//        let navigationController = UINavigationController(rootViewController: rankViewController)
//        self.presentViewController(navigationController, animated: true, completion: nil)

    }

    @IBAction func loginAsSameUser(sender: AnyObject) {
        let fbid = self.userP.stringForKey("fb_id")!
        let name = self.userP.stringForKey("fb_name")!

        self.sendUpdateRequest(name, fbid: fbid)
    }



    // *************
    // Facebook login

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if error != nil {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
//            print("cancel")
        } else {
            // Navigate to other view

            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if error == nil {
                    let FBID = result.objectForKey("id") as! String
                    let name = result.objectForKey("name") as! String
                    self.sendUpdateRequest( name, fbid: FBID )

                    self.userP.setValue( FBID, forKey: "fb_id" )
                    self.userP.setValue( name, forKey: "fb_name" )
                }

            }) // --- graphRequest
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.sameUserButton.hidden = true
        self.sameUserButton.setTitle("", forState: .Normal)

        self.userP.removeObjectForKey("fb_id")
        self.userP.removeObjectForKey("fb_name")
    }

}
