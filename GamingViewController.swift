//
//  ViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 11/16/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class GamingViewController: UIViewController {

    @IBOutlet var startView: UIView!
    @IBOutlet var gameView: UIView!

    @IBOutlet var LeftTopButton: UIButton!
    @IBOutlet var LeftBottomButton: UIButton!
    @IBOutlet var RightTopButton: UIButton!
    @IBOutlet var RightBottomButton: UIButton!
    @IBOutlet var clock: UILabel!
    @IBOutlet var questionTitle: UILabel!

    var colorTextArray: [String] = ["red","blue","yellow","black","green"]
    var colorArray: [String] = ["green","blue","black","red"]

    var currentSecond: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareNewGame()
    }

    @IBAction func gameStart(sender: AnyObject) {
        self.startView.hidden = true
        self.gameView.hidden = false

        // Start timer
        NSTimer.scheduledTimerWithTimeInterval( 0.1, target: self, selector: "addTimer:", userInfo: nil, repeats: true )

        // First question
        self.updateQuestion()
    }

    func prepareNewGame() {

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

    }

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
print(buttonColor)
//        switch(buttonColor) {
//            case "green":
//            case "blue":
//            case "black":
//            default:
//            // red
//        }
        self.updateQuestion()
    }

    func addTimer( timer: NSTimer ) {
        self.currentSecond += 0.1
        self.clock.text = NSString( format: "%.1f", self.currentSecond ) as String
    }

    func updateQuestion() {
        self.questionTitle.text = self.colorTextArray.randomItem()
        switch( self.colorArray.randomItem() ) {
            case "red":
                self.questionTitle.textColor = UIColor.redColor()
            case "blue":
                self.questionTitle.textColor = UIColor.blueColor()
            case "black":
                self.questionTitle.textColor = UIColor.blackColor()
            default:
            // green
                self.questionTitle.textColor = UIColor.greenColor()
        }
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