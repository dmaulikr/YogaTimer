//
//  ViewController.swift
//  YogaTimer
//
//  Created by Sushrut Shringarputale on 7/10/17.
//  Copyright © 2017 Sushrut Shringarputale. All rights reserved.
//
import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MDCActivityIndicator
import AVFoundation
import Atomic

class ViewController: UIViewController, SpeedSetDelegate {
    @IBOutlet weak var yogaFiller : MDCActivityIndicator!
    @IBOutlet weak var resetButton : MDCRaisedButton!
    @IBOutlet weak var maxTimerValueLabel: UILabel!
    
    
    
    let buttonColor : UIColor = UIColor.init(red: 0xF4/0xFF, green: 0x43/0xFF, blue: 0x36/0xFF, alpha: 0xFF/0xFF)
    
    private let timerRunningState = Atomic<Bool>(false)
    
    var currentTimerValue : CGFloat = 0
    var maxCountValue : CGFloat = 0
    var AVSpeaker : AVSpeechSynthesizer = AVSpeechSynthesizer.init()
    var timer : Timer?
    var speed : CGFloat = 1.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yogaFiller.cycleColors = [buttonColor, UIColor.darkGray]
        yogaFiller.strokeWidth = 3.0
        yogaFiller.setIndicatorMode(.determinate, animated: true)
        yogaFiller.trackEnabled = true
        yogaFiller.radius = yogaFiller.frame.width / 2
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setBackgroundColor(buttonColor, for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.sizeToFit()
        resetButton.addTarget(self, action: #selector(ViewController.reset), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var currentPanValue : CGFloat = 0
    @IBAction func updateTimerValue(_ panGestureRecognizer : UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed && currentTimerValue == 0 {
            currentPanValue += panGestureRecognizer.velocity(in: yogaFiller).y
            maxCountValue = fabs((currentPanValue * -0.005).rounded(.down))
            maxTimerValueLabel.text = (Int(fabs(currentPanValue * -0.005))).description
        }
        if panGestureRecognizer.state == .ended && currentTimerValue == 0{
            maxTimerValueLabel.text = 0.description
            currentPanValue = 0
        }
    }
    
    func reset () {
        print("Reset clicked")
        timer?.invalidate()
        currentTimerValue = 0
        maxCountValue = 0
        maxTimerValueLabel.text = 0.description
        yogaFiller.progress = 0
        yogaFiller.isAnimating = false
        timerRunningState.value = false
    }
    
    func partialReset() {
        currentTimerValue = 0
        timerRunningState.value = false
        yogaFiller.progress = 0
    }
    
    @IBAction func start(_ sender: UITapGestureRecognizer) {
        print("Start clicked")
        yogaFiller.startAnimating()
        yogaFiller.progress = Float(currentTimerValue / self.maxCountValue)
        if (!timerRunningState.swap(newValue: true)) {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(speed), repeats: true, block: { (Timer) in
                if (self.currentTimerValue < self.maxCountValue) {
                    self.currentTimerValue += 1
                    self.maxTimerValueLabel.text = Int(self.currentTimerValue).description
                    self.yogaFiller.progress = Float(self.currentTimerValue / self.maxCountValue)
                    let utterance = AVSpeechUtterance.init(string: Int(self.currentTimerValue).description)
                    utterance.rate = (Float(self.speed >= 1 ? CGFloat.init(0.5) : CGFloat.init(0.5) + (CGFloat.init(1.0)-(self.speed/2))))
                    self.AVSpeaker.speak(utterance)
                } else {
                    self.yogaFiller.stopAnimating()
                    self.timer?.invalidate()
                    self.partialReset()
                }
            })
            animateLoading()
            timer!.fireDate = Date.init(timeInterval: 2.5, since: .init())
        } else {
            timer?.invalidate()
            timerRunningState.value = false;
        }
    }
    
    func setNewSpeed(speed: CGFloat) {
        self.speed = speed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "setTimerSpeed") {
            let timerSetVC = segue.destination as! TimerStepViewController
            timerSetVC.speed = self.speed
            timerSetVC.speedSetDelegate = self
        }
    }
    
    func animateLoading() {
        yogaFiller.progress = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            // Put your code which should be executed with a delay here
            self.yogaFiller.progress = Float(self.currentTimerValue / self.maxCountValue)
        })
    }
}

