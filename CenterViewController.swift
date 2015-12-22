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
    var endingViewController: EndingViewController?
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    var timer = NSTimer()
    var currentSecond: Int = 0 // output = currentSecond / 100

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StartView") as? StartViewController
        self.effectViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EffectView") as? EffectViewController
        self.gameViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameView") as? GameViewController
        self.endingViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EndingView") as? EndingViewController

        self.currentViewController = self.startViewController
    }
    
    func prepareNewGame() {
        
        // Initialize variables
        self.currentSecond = 0
//        self.answeredQuestion = 0
//        self.clock.text = "0"
        self.effectViewController?.newGame()
        self.gameViewController?.newGame()
        self.endingViewController?.newGame()

        self.currentViewController = self.effectViewController

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