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

    var colorTextArray: [String] = ["Red","Blue","Yellow","Black","Green"]
    var colorArray: [String] = ["green","blue","black","red"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.prepareNewGame()
    }

    @IBAction func gameStart(sender: AnyObject) {
        self.startView.hidden = true
        self.gameView.hidden = false
    }

    func prepareNewGame() {

        // Resort array
        colorArray = colorArray.sort({ (c1: String, color2: String) -> Bool in
            let a = Int( arc4random_uniform(50) )
            let b = Int( arc4random_uniform(50) )
            return a > b
        })

//        // Set text on the buttons
//        self.textOnLeftTopBtn.text = self.colorArray[0]
//        self.textOnLeftBottomBtn.text = self.colorArray[1]
//        self.textOnRightTopBtn.text = self.colorArray[2]
//        self.textOnRightBottomBtn.text = self.colorArray[3]
//
//        let greenGesture = UITapGestureRecognizer(target: self, action: "isGreen")
//        let redGesture = UITapGestureRecognizer(target: self, action: "isRed")
//        let blackGesture = UITapGestureRecognizer(target: self, action: "isBlack")
//        let blueGesture = UITapGestureRecognizer(target: self, action: "isBlue")
//        func returnGesture( index: Int ) -> UITapGestureRecognizer {
//            switch( colorArray[index] ) {
//                case "green":
//                    return greenGesture
//                case "red":
//                    return redGesture
//                case "black":
//                    return blackGesture
//                default:
//                    return blueGesture
//            }
//        }
//
//        self.LeftTopButton.addGestureRecognizer( returnGesture(0) )
//        self.LeftBottomButton.addGestureRecognizer( returnGesture(1) )
//        self.RightTopButton.addGestureRecognizer( returnGesture(2) )
//        self.RightBottomButton.addGestureRecognizer( returnGesture(3) )
    }

    @IBAction func clickLeftTopButton(sender: AnyObject) {
        print("LeftTop")
    }

    @IBAction func clickLeftBottomButton(sender: AnyObject) {
        print("LeftBottom")
    }

    @IBAction func clickRightTopButton(sender: AnyObject) {
        print("RightTop")
    }

    @IBAction func clickRightBottomButton(sender: AnyObject) {
        print("RightBottom")
    }

    func isGreen() {
        //
        print("is green")
    }

    func isRed() {
        //
        print("is red")
    }

    func isBlack() {
        //
        print("is black")
    }

    func isBlue() {
        //
        print("is blue")
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