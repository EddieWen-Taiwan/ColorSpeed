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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

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
                    if let parentVC = self.parentViewController as? CenterViewController {
                        parentVC.currentViewController = parentVC.gameViewController
                        // Start timer
                        parentVC.timer = NSTimer.scheduledTimerWithTimeInterval( 0.02, target: parentVC, selector: "addTimer:", userInfo: nil, repeats: true )
                    }

                })
            })
        })

    }

    func newGame() {
        self.three.transform = CGAffineTransformIdentity
        self.two.hidden = true
        self.two.transform = CGAffineTransformIdentity
        self.one.hidden = true
        self.one.transform = CGAffineTransformIdentity
    }

}
