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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let yogaFiller : MBCircularProgressBarView = self.view.viewWithTag(<#T##tag: Int##Int#>)
        self.view.addSubview(yogaFiller)
        let raisedButton = MDCRaisedButton.init()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

