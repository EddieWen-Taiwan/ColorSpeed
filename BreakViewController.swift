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
        if let name = self.userDefaults.stringForKey("username") {
            self.nameTextField.text = name
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func register(sender: AnyObject) {
    }

    @IBAction func registerAsSameUser(sender: AnyObject) {
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
