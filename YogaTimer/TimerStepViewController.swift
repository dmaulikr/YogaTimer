//
//  TimerStepViewController.swift
//  YogaTimer
//
//  Created by Sushrut Shringarputale on 7/14/17.
//  Copyright © 2017 Sushrut Shringarputale. All rights reserved.
//
import Foundation
import UIKit

class TimerStepViewController : UIViewController {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStepper: UIStepper!
    
    weak var speedSetDelegate : SpeedSetDelegate?
    
    var speed : CGFloat?
    
    override func viewDidLoad() {
        if (speed == nil) {
            speed = 1.0
        }
        speedLabel.text = speed?.description
    }
    
    
    @IBAction func stepperValueEvent(sender: UIStepper) {
        speedLabel.text = speedStepper.value.description
        speed = CGFloat(speedStepper.value)
    }
    @IBAction func done(_ sender: UITapGestureRecognizer) {
        self.speedSetDelegate?.setNewSpeed(speed: speed!)
        self.dismiss(animated: true) { 
            NSLog("Done")
        }
    }
}

