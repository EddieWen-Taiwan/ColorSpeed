//
//  EndingViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/19/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class EndingViewController: UIViewController {

    @IBOutlet var finalTimeLabel: UILabel!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!

    var parentVC: CenterViewController!

    var didViewLoad: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.didViewLoad = true

        self.parentVC = self.parentViewController as! CenterViewController
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.finalTimeLabel.text = parentVC.currentSecond.displayText()
        self.centerYConstraint.constant = -100
        UIView.animateWithDuration( 1, animations: {
            self.finalTimeLabel.transform = CGAffineTransformMakeScale(1.7, 1.7)
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func playAgain(sender: AnyObject) {
        parentVC.prepareNewGame()
    }

    func newGame() {
        if self.didViewLoad {
            self.centerYConstraint.constant = -140
            self.finalTimeLabel.transform = CGAffineTransformIdentity
        }
    }

}
