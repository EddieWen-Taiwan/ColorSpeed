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
    }

}
