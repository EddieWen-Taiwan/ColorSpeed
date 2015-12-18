//
//  EffectViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/18/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import Spring

class EffectViewController: UIViewController {

    @IBOutlet var three: SpringLabel!
    @IBOutlet var two: SpringLabel!
    @IBOutlet var one: SpringLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.countdownGame()
    }

    func countdownGame() {

        self.three.animation = "zoomOut"
        self.three.animateToNext({
            self.two.hidden = false
            self.two.animation = "zoomOut"
            self.two.animateToNext({
                self.one.hidden = false
                self.one.animation = "zoomOut"
                self.one.animateToNext({
                    // Game Start
                    let parentVC = self.parentViewController as! CenterViewController

//                    self.gameView.hidden = false
                    // Start timer
//                    self.timer = NSTimer.scheduledTimerWithTimeInterval( 0.02, target: self, selector: "addTimer:", userInfo: nil, repeats: true )
                    self.initEffectTransform()
                })
            })
        })

    }

    func initEffectTransform() {
        self.three.transform = CGAffineTransformIdentity
        self.two.hidden = true
        self.two.transform = CGAffineTransformIdentity
        self.one.hidden = true
        self.one.transform = CGAffineTransformIdentity
        
//        self.endingTimeLabel.transform = CGAffineTransformIdentity
//        self.topConstraintOfTimeLabel.constant = 0
        self.view.layoutIfNeeded()
    }

}
