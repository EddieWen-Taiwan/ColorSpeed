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

    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.centerYConstraint.constant = -140
        self.finalTimeLabel.transform = CGAffineTransformIdentity
    }

    func checkRank() {
        
        if Reachability().isConnectedToNetwork() {
            let httpRequest = NSMutableURLRequest(URL: NSURL( string: ServerTalker.checkTimeInLastRow )!)
            httpRequest.HTTPMethod = "POST"
            
            let postString = "time=\(self.currentSecond.displayText())"
            httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let checkNewData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, info, error) in
                
                if error == nil {
                    let status = JSON( data: response! )
                    if status["better"] {
                        // Download new ranl data from server
                        self.newRank = status["rank"].int!
                        dispatch_async( dispatch_get_main_queue(), {
                            self.newTimeRecordLabel.text = self.endingTimeLabel.text
                            // Show break view
                            if FBSDKAccessToken.currentAccessToken() == nil {
                                self.sameUserButton.hidden = true
                            } else {
                                self.sameUserButton.hidden = false
                                if let username = self.userP.stringForKey("fb_name") {
                                    self.sameUserButton.setTitle("Yes, I'm \(username)", forState: .Normal)
                                }
                            }
                            self.breakView.hidden = false
                            self.breakView.animation = "pop"
                            self.breakView.animate()
                        })
                    }
                }
                
            }
            checkNewData.resume()
        }
        
    }

}
