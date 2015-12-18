//
//  CenterViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 12/18/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {

    @IBOutlet var containerView: UIView!

    var colorTextArray: [String] = ["red","blue","yellow","black","green"]
    var colorArray: [String] = ["green","blue","black","red"]

    var currentSecond: Int = 0 // output = currentSecond / 100
    var answeredQuestion: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareNewGame() {
        
        // Initialize variables
        self.currentSecond = 0
        self.answeredQuestion = 0
//        self.clock.text = "0"
        
        // Resort array
        colorArray = colorArray.sort({ (c1: String, color2: String) -> Bool in
            let a = Int( arc4random_uniform(50) )
            let b = Int( arc4random_uniform(50) )
            return a > b
        })
        
//        // Set text on the buttons
//        self.LeftTopButton.setTitle( self.colorArray[0], forState: .Normal )
//        self.LeftBottomButton.setTitle( self.colorArray[1], forState: .Normal )
//        self.RightTopButton.setTitle( self.colorArray[2], forState: .Normal )
//        self.RightBottomButton.setTitle( self.colorArray[3], forState: .Normal )
//        
//        // First question
//        self.updateQuestion()
        
    }

}
