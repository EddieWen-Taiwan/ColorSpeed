//
//  CenterViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/18/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON

class CenterViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    var currentViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var startViewController: StartViewController!
    var effectViewController: EffectViewController!
    var gameViewController: GameViewController!
    var breakViewController: BreakViewController!
    var endingViewController: EndingViewController!

    @IBOutlet var breakViewContainer: SpringView!

    var timer = NSTimer()
    var currentSecond: Int = 0 // output = currentSecond / 100

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StartView") as! StartViewController
        self.effectViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EffectView") as! EffectViewController
        self.gameViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as! GameViewController
        self.breakViewController = self.childViewControllers.first as! BreakViewController
        self.endingViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EndingView") as! EndingViewController

        self.currentViewController = self.startViewController
    }

    func prepareNewGame() {

        // Initialize variables
        self.currentSecond = 0

        self.effectViewController?.newGame()
        self.gameViewController?.newGame()
        self.endingViewController?.newGame()

        self.currentViewController = self.effectViewController

    }

    func checkRank() {
        
        if Reachability().isConnectedToNetwork() {
            let httpRequest = NSMutableURLRequest(URL: NSURL( string: ServerTalker.checkTimeInLastRow )!)
            httpRequest.HTTPMethod = "POST"
            
            let postString = "time=\(parentVC.currentSecond.displayText())"
            httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let checkNewData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, info, error) in
                
                var nextVC = "ending"
                
                if error == nil {
                    let status = JSON( data: response! )
                    if status["better"] {
                        // Download new ranl data from server
                        self.newRank = status["rank"].int!
                        nextVC = "break"
                        
                        //                        dispatch_async( dispatch_get_main_queue(), {
                        //                            self.newTimeRecordLabel.text = self.endingTimeLabel.text
                        //                            // Show break view
                        //                            if FBSDKAccessToken.currentAccessToken() == nil {
                        //                                self.sameUserButton.hidden = true
                        //                            } else {
                        //                                self.sameUserButton.hidden = false
                        //                                if let username = self.userP.stringForKey("fb_name") {
                        //                                    self.sameUserButton.setTitle("Yes, I'm \(username)", forState: .Normal)
                        //                                }
                        //                            }
                        //                            self.breakView.hidden = false
                        //                            self.breakView.animation = "pop"
                        //                            self.breakView.animate()
                        //                        })
                    } else {
                        print("not better")
                    }
                }
                
                dispatch_async( dispatch_get_main_queue(), {
                    //                    self.parentVC.currentViewController = nextVC == "break" ? self.parentVC.breakViewController : self.parentVC.endingViewController
                })
                
            }
            checkNewData.resume()
        }
        
    }

    func breakRecord() {
        self.breakViewContainer.hidden = false
        self.breakViewContainer.animation = "pop"
        self.breakViewContainer.animate()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "break" {
            if let nextVC = segue.destinationViewController as? BreakViewController {
                nextVC.parentVC = self
            }
        }
    }

    func addTimer( timer: NSTimer ) {
        self.currentSecond += 2

        var displayT = self.currentSecond.displayText()
        displayT.removeAtIndex(displayT.endIndex.predecessor())

        if gameViewController?.clock.text != displayT {
            gameViewController?.clock.text = displayT
        }
    }

    // COPY
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)

            inActiveVC.view.removeFromSuperview()

            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }

    private func updateActiveViewController() {
        if let activeVC = currentViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)

            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)

            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }

}

extension Int {
    func displayText() -> String {
        return NSString( format: "%.2f", Double(self)/100 ) as String
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int( arc4random_uniform( UInt32(self.count) ) )
        return self[index]
    }
}