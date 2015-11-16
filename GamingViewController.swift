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