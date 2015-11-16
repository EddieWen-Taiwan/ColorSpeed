//
//  ViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 11/16/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gameViewContainer: UIView!
    var gamingViewController = GamingViewController()

    @IBOutlet var startView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func gameStart(sender: AnyObject) {
        self.startView.hidden = true
        self.gameViewContainer.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

