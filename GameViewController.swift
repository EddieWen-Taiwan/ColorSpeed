//
//  GameViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/18/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import Spring

class GameViewController: UIViewController {

    var colorTextArray: [String] = [ "red", "blue", "yellow", "black", "green" ]
    var colorArray: [String] = [ "green", "blue", "black", "red" ]

    let totalQuestion: Int = 20
    var answeredQuestion: Int = 0
    var currentText: String!
    var currentColor: String!

    var parentVC: CenterViewController!

    @IBOutlet var LeftTopButton: UIButton!
    @IBOutlet var LeftBottomButton: UIButton!
    @IBOutlet var RightTopButton: UIButton!
    @IBOutlet var RightBottomButton: UIButton!

    @IBOutlet var clock: UILabel!
    @IBOutlet var questionTitle: UILabel!
    @IBOutlet var warningView: SpringView!
    @IBOutlet var plus2second: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        // Resort array
        colorArray = colorArray.sort({ (c1: String, color2: String) -> Bool in
            let a = Int( arc4random_uniform(50) )
            let b = Int( arc4random_uniform(50) )
            return a > b
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.parentVC = self.parentViewController as! CenterViewController
        
        // Set text on the buttons
        self.LeftTopButton.setTitle( self.colorArray[0], forState: .Normal )
        self.LeftBottomButton.setTitle( self.colorArray[1], forState: .Normal )
        self.RightTopButton.setTitle( self.colorArray[2], forState: .Normal )
        self.RightBottomButton.setTitle( self.colorArray[3], forState: .Normal )

        // First question
        self.updateQuestion()
    }

    @IBAction func clickColorButton(sender: UIButton) {
        self.answerColor( sender.tag )
    }
    
    func answerColor( buttonIndex: Int ) {
        let buttonColor = self.colorArray[buttonIndex]

        if buttonColor == self.currentColor {
            // Answer is correct
            if self.answeredQuestion == self.totalQuestion-1 {
                // End game
                parentVC.timer.invalidate()
//                self.endingTimeLabel.text = self.currentSecond.displayText()
//
//                self.checkRank()

                // Show ending view
                parentVC.currentViewController = parentVC.endingViewController

                // TimeLabel animation
//                self.topConstraintOfTimeLabel.constant = 50
//                UIView.animateWithDuration( 1, animations: {
//                    self.endingTimeLabel.transform = CGAffineTransformMakeScale(1.7, 1.7)
//                    self.view.layoutIfNeeded()
//                })

            } else {
                // Next one
                self.answeredQuestion++
                self.updateQuestion()
            }
        } else {
            // Answer is wrong
            // WarningView animation
            UIView.animateWithDuration( 0.2, animations: {
                self.warningView.alpha = 1
            }, completion: { finish in
                self.warningView.animation = "shake"
                self.warningView.animate()
                UIView.animateWithDuration( 0.2, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.warningView.alpha = 0
                }, completion: { finish in })
            })

            // Plus 2 seconds animation
            self.plus2second.alpha = 1
            UIView.animateWithDuration( 0.7, animations: {
                self.plus2second.layer.position.y -= 70
                self.plus2second.alpha = 0
            }, completion: { finish in
                self.plus2second.layer.position.y += 70
            })

            // Punish: plus two seconds
            self.parentVC.currentSecond += 200
            var displayT = self.parentVC.currentSecond.displayText()
            displayT.removeAtIndex(displayT.endIndex.predecessor())
            self.clock.text = displayT
        }
    }

    func updateQuestion() {

        let nextText = self.colorTextArray.randomItem()
        let nextColor = self.colorArray.randomItem()

        if nextText != self.currentText || nextColor != self.currentColor {
            self.currentText = nextText
            self.questionTitle.text = self.currentText

            self.currentColor = nextColor
            switch( nextColor ) {
                case "red":
                    self.questionTitle.textColor = UIColor.redColor()
                case "blue":
                    self.questionTitle.textColor = UIColor.blueColor()
                case "black":
                    self.questionTitle.textColor = UIColor.blackColor()
                default: // green
                    self.questionTitle.textColor = UIColor.greenColor()
            }
        } else {
            updateQuestion()
        }

    }

}
