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

class GamingViewController: UIViewController, UITextFieldDelegate {

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

}
