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

class GamingViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet var startView: UIView!
    @IBOutlet var effectView: UIView!
    @IBOutlet var gameView: UIView!
    @IBOutlet var endingView: UIView!
    @IBOutlet var breakView: SpringView!

    // in effect view
    @IBOutlet var three: SpringLabel!
    @IBOutlet var two: SpringLabel!
    @IBOutlet var one: SpringLabel!

    // in game view
    @IBOutlet var LeftTopButton: UIButton!
    @IBOutlet var LeftBottomButton: UIButton!
    @IBOutlet var RightTopButton: UIButton!
    @IBOutlet var RightBottomButton: UIButton!
    @IBOutlet var clock: UILabel!
    @IBOutlet var questionTitle: UILabel!
    @IBOutlet var warningView: SpringView!
    @IBOutlet var plus2second: UILabel!

    // in ending view
    @IBOutlet var endingTimeLabel: UILabel!
    @IBOutlet var topConstraintOfTimeLabel: NSLayoutConstraint!

    // in break view
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var newTimeRecordLabel: UILabel!
    @IBOutlet var FBLoginView: UIView!
    @IBOutlet var sameUserButton: UIButton!

    let serverTalker = ServerTalker()
    let userP = NSUserDefaults.standardUserDefaults()

    var colorTextArray: [String] = ["red","blue","yellow","black","green"]
    var colorArray: [String] = ["green","blue","black","red"]

    var timer = NSTimer()
    var currentSecond: Int = 0 // output = currentSecond / 100
    var currentColor: String!
    let totalQuestion: Int = 20 // <-----
    var answeredQuestion: Int = 0
    var newRank: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareNewGame()

        // Preenter user name
        if let username = self.userP.stringForKey("username") {
            self.nameTextField.text = username
        }

        self.nameTextField.delegate = self
        // Add Facebook login button
        self.view.layoutIfNeeded()

        let loginView = FBSDKLoginButton()
        self.FBLoginView.addSubview( loginView )
        loginView.frame = CGRectMake( 0, 0, self.FBLoginView.frame.width, self.FBLoginView.frame.height )
        loginView.readPermissions = [ "public_profile" ]
        loginView.delegate = self
    }




    // *************
    // Start View

    @IBAction func gameStart(sender: AnyObject) {
        self.startView.hidden = true
        self.beReadyToGame()
    }

    func prepareNewGame() {

        // Initialize variables
        self.currentSecond = 0
        self.answeredQuestion = 0
        self.clock.text = "0"

        // Resort array
        colorArray = colorArray.sort({ (c1: String, color2: String) -> Bool in
            let a = Int( arc4random_uniform(50) )
            let b = Int( arc4random_uniform(50) )
            return a > b
        })

        // Set text on the buttons
        self.LeftTopButton.setTitle( self.colorArray[0], forState: .Normal )
        self.LeftBottomButton.setTitle( self.colorArray[1], forState: .Normal )
        self.RightTopButton.setTitle( self.colorArray[2], forState: .Normal )
        self.RightBottomButton.setTitle( self.colorArray[3], forState: .Normal )

        // First question
        self.updateQuestion()

    }
    
    
    
    
    // *************
    // Effect View

    // Countdown animation 3... 2... 1...
    func beReadyToGame() {
        self.effectView.hidden = false

        self.three.animation = "zoomOut"
        self.three.animateToNext({
            self.two.hidden = false
            self.two.animation = "zoomOut"
            self.two.animateToNext({
                self.one.hidden = false
                self.one.animation = "zoomOut"
                self.one.animateToNext({
                    // Game Start
                    self.effectView.hidden = true
                    self.gameView.hidden = false
                    // Start timer
                    self.timer = NSTimer.scheduledTimerWithTimeInterval( 0.02, target: self, selector: "addTimer:", userInfo: nil, repeats: true )
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

        self.endingTimeLabel.transform = CGAffineTransformIdentity
        self.topConstraintOfTimeLabel.constant = 0
        self.view.layoutIfNeeded()
    }




    // *************
    // Game View

    @IBAction func clickLeftTopButton(sender: AnyObject) {
        self.answerColor(0)
    }

    @IBAction func clickLeftBottomButton(sender: AnyObject) {
        self.answerColor(1)
    }

    @IBAction func clickRightTopButton(sender: AnyObject) {
        self.answerColor(2)
    }

    @IBAction func clickRightBottomButton(sender: AnyObject) {
        self.answerColor(3)
    }

    func answerColor( buttonIndex: Int ) {
        let buttonColor = self.colorArray[buttonIndex]

        if buttonColor == self.currentColor {
            // Answer is correct
            if self.answeredQuestion == self.totalQuestion-1 {
                // End game
                self.timer.invalidate()
                self.endingTimeLabel.text = self.currentSecond.displayText()

                self.checkRank()

                // Show ending view
                self.gameView.hidden = true
                self.endingView.hidden = false

                // TimeLabel animation
                self.topConstraintOfTimeLabel.constant = 50
                UIView.animateWithDuration( 1, animations: {
                    self.endingTimeLabel.transform = CGAffineTransformMakeScale(1.7, 1.7)
                    self.view.layoutIfNeeded()
                })

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
            self.currentSecond += 200
            var displayT = self.currentSecond.displayText()
            displayT.removeAtIndex(displayT.endIndex.predecessor())
            self.clock.text = displayT
        }
    }

    func addTimer( timer: NSTimer ) {
        self.currentSecond += 2

        var displayT = self.currentSecond.displayText()
        displayT.removeAtIndex(displayT.endIndex.predecessor())

        if self.clock.text != displayT {
            self.clock.text = displayT
        }
    }

    func updateQuestion() {
        self.questionTitle.text = self.colorTextArray.randomItem()
        switch( self.colorArray.randomItem() ) {
            case "red":
                self.questionTitle.textColor = UIColor.redColor()
                self.currentColor = "red"
            case "blue":
                self.questionTitle.textColor = UIColor.blueColor()
                self.currentColor = "blue"
            case "black":
                self.questionTitle.textColor = UIColor.blackColor()
                self.currentColor = "black"
            default: // green
                self.questionTitle.textColor = UIColor.greenColor()
                self.currentColor = "green"
        }
    }




    // *************
    // Ending View

    @IBAction func playAgain(sender: AnyObject) {
        // Clear current variables and restart
        self.prepareNewGame()
        self.endingView.hidden = true
        self.beReadyToGame()
    }

    func checkRank() {

        if Reachability().isConnectedToNetwork() {
            let httpRequest = NSMutableURLRequest(URL: NSURL( string: serverTalker.checkTimeInLastRow )!)
            httpRequest.HTTPMethod = "POST"

            let postString = "time=\(self.currentSecond.displayText())"
            httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

            let checkNewData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, data, error) in

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




    // *************
    // Break View

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pressSendButton(sender: AnyObject) {

        // Get the name
        var name = self.nameTextField.text!
        if name != "" {
            self.userP.setValue( name, forKey: "username" )
        } else {
            name = ">__<"
        }

        self.sendUpdateRequest( name )

    }

    func sendUpdateRequest( username: String, fbid: String = "" ) {

        let httpRequest = NSMutableURLRequest(URL: NSURL( string: serverTalker.update )!)
        httpRequest.HTTPMethod = "POST"

        var postString = "name=\(username)&time=\(self.currentSecond.displayText())&rank=\(self.newRank)"
        if fbid != "" {
            postString += "&fbid=\(fbid)"
        }
        httpRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let updateData = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, data, error) in

            if error == nil {
                print( JSON(data: response!) )
            }

        }
        updateData.resume()

        // Hide this BreakView
        self.breakView.hidden = true

        // Present RankTableViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rankViewController = storyboard.instantiateViewControllerWithIdentifier("RankTable") as! RankTableViewController
        rankViewController.newDataRow = self.newRank
        rankViewController.forceUpdate = true
        let navigationController = UINavigationController(rootViewController: rankViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)

    }

    @IBAction func loginAsSameUser(sender: AnyObject) {
        let fbid = self.userP.stringForKey("fb_id")!
        let name = self.userP.stringForKey("fb_name")!

        self.sendUpdateRequest(name, fbid: fbid)
    }



    // *************
    // Facebook login

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if error != nil {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
            print("cancel") // Add alert
        } else {
            // Navigate to other view

            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if error == nil {
                    let FBID = result.objectForKey("id") as! String
                    let name = result.objectForKey("name") as! String
                    self.sendUpdateRequest( name, fbid: FBID )

                    self.userP.setValue( FBID, forKey: "fb_id" )
                    self.userP.setValue( name, forKey: "fb_name" )
                }

            }) // --- graphRequest
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Array {
    func randomItem() -> Element {
        let index = Int( arc4random_uniform( UInt32(self.count) ) )
        return self[index]
    }
}

extension Int {
    func displayText() -> String {
        return NSString( format: "%.2f", Double(self)/100 ) as String
    }
}