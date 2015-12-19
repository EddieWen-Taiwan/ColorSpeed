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
    var currentViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    var startViewController: StartViewController?
    var effectViewController: EffectViewController?
    var gameViewController: GameViewController?
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    var timer = NSTimer()
    var currentSecond: Int = 0 // output = currentSecond / 100

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StartView") as? StartViewController
        self.effectViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EffectView") as? EffectViewController
        self.gameViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as? GameViewController

        self.currentViewController = self.startViewController
    }
    
    func prepareNewGame() {
        
        // Initialize variables
        self.currentSecond = 0
//        self.answeredQuestion = 0
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
