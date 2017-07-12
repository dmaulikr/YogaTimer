//
//  ViewController.swift
//  YogaTimer
//
//  Created by Sushrut Shringarputale on 7/10/17.
//  Copyright © 2017 Sushrut Shringarputale. All rights reserved.
//
import UIKit
import MaterialComponents.MaterialButtons
import MBCircularProgressBar
import AVFoundation
import Atomic

class ViewController: UIViewController {
    @IBOutlet weak var yogaFiller : MBCircularProgressBarView!
    @IBOutlet weak var resetButton : MDCRaisedButton!
    @IBOutlet weak var maxTimerValueLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStepper: UIStepper!
    
    
    let buttonColor : UIColor = UIColor.init(red: 0xF4/0xFF, green: 0x43/0xFF, blue: 0x36/0xFF, alpha: 0xFF/0xFF)
    
    private let timerRunningState = Atomic<Bool>(false)
    private let animate = Atomic<Bool>(true)
    
    var currentTimerValue : CGFloat = 0
    var maxCountValue : CGFloat = 0
    var AVSpeaker : AVSpeechSynthesizer = AVSpeechSynthesizer.init()
    var timer : Timer?
    var speed : CGFloat = 1.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yogaFiller.value = 0
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setBackgroundColor(buttonColor, for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.sizeToFit()
        resetButton.addTarget(self, action: #selector(ViewController.reset), for: .touchUpInside)
        
        
        maxTimerValueLabel.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var currentPanValue : CGFloat = 0
    @IBAction func updateTimerValue(_ panGestureRecognizer : UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {
            yogaFiller.showValueString = false
            maxTimerValueLabel.isHidden = false
            currentPanValue += panGestureRecognizer.velocity(in: yogaFiller).y
            maxCountValue = (currentPanValue * -0.005).rounded(.down)
            print(maxCountValue)
            maxTimerValueLabel.text = (Int(currentPanValue * -0.005)).description
            yogaFiller.maxValue = maxCountValue
        }
        if panGestureRecognizer.state == .ended {
            maxTimerValueLabel.isHidden = true
            yogaFiller.showValueString = true
            currentPanValue = 0
        }
    }
    
    func reset () {
        print("Reset clicked")
        currentTimerValue = 0
        yogaFiller.value = 0
        yogaFiller.maxValue = 0
        maxCountValue = 0
        timerRunningState.value = false
    }
    
    func partialReset() {
        currentTimerValue = 0
        yogaFiller.value = 0
        timerRunningState.value = false
    }
    
    @IBAction func start(_ sender: UITapGestureRecognizer) {
        print("Start clicked")
        if (!timerRunningState.value) {
            timerRunningState.value = true
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(speed), repeats: true, block: { (Timer) in
                self.animate.value = false
                if (self.currentTimerValue < self.maxCountValue) {
                    self.currentTimerValue += 1
                    self.yogaFiller.value = self.currentTimerValue
                    let utterance = AVSpeechUtterance.init(string: Int(self.currentTimerValue).description)
                    utterance.rate = (Float(self.speed > 1 ? CGFloat.init(0.5) : CGFloat.init(0.5) + (CGFloat.init(1.0)-(self.speed/2))))
                    print(utterance.rate)
                    self.AVSpeaker.speak(utterance)
                } else {
                    self.timer?.invalidate()
                    self.partialReset()
                }
            })
            timer!.fireDate = Date.init(timeInterval: 4, since: Date.init())
            self.animate.value = true
            animateButton(start: self.animate.value)
        } else {
            timer?.invalidate()
            timerRunningState.value = false;
        }
    }
    
    
    func animateButton(start : Bool) -> Void {
        if (start) {
            UIView.animate(withDuration: 1, animations: {
                self.maxTimerValueLabel.isHidden = false
                self.yogaFiller.showValueString = false
                self.maxTimerValueLabel.transform = CGAffineTransform.init(rotationAngle: 360)
            })
            animateButton(start: self.animate.value)
        } else {
            self.maxTimerValueLabel.isHidden = true
            self.yogaFiller.showValueString = true

        }
    }
    
    @IBAction func stepperValueEvent(sender: UIStepper) {
        speedLabel.text = speedStepper.value.description
        speed = CGFloat(speedStepper.value)
    }
}

