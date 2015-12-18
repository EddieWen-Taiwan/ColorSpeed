//
//  StartViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/18/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func gameStart(sender: AnyObject) {
        print("click")

        let parentVC = self.parentViewController as! CenterViewController
        parentVC.currentViewController = parentVC.effectViewController
    }

}
