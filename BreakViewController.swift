//
//  BreakViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/23/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class BreakViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var newTimeLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var FBLoginView: UIView!
    @IBOutlet var sameUserButton: UIButton!

    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let name = self.userDefaults.stringForKey("username") {
            self.nameTextField.text = name
        } else {
            self.nameTextField.text = ""
        }
    }

    @IBAction func register(sender: AnyObject) {

        // Get the name
        var name = self.nameTextField.text ?? ""
        if name == "" {
            name = ">__<"
        } else {
            self.userDefaults.setValue( name, forKey: "username" )
        }

//        self.sendUpdateRequest( name )

    }

    @IBAction func registerAsSameUser(sender: AnyObject) {
    }

    func sendUpdateRequest( username: String, fbid: String = "" ) {
        
        let httpRequest = NSMutableURLRequest(URL: NSURL( string: ServerTalker.update )!)
            httpRequest.HTTPMethod = "POST"

        var postString = "name=\(username)&time=\(self.currentSecond.displayText())&rank=\(self.newRank)"
        if fbid != "" {
            postString += "&fbid=\(fbid)"
        }
        httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let updateData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest )
        updateData.resume()
        
        // Hide this BreakView
        self.breakView.hidden = true
        
        // Present RankTableViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rankViewController = storyboard.instantiateViewControllerWithIdentifier("RankTable") as! RankTableViewController
            rankViewController.newDataRow = self.newRank
            rankViewController.forceUpdate = true
        let navigationController = UINavigationController(rootViewController: rankViewController)

        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
