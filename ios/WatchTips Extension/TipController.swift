//
//  TipController.swift
//  WatchTips Extension
//
//  Created by Stephen Rogers on 27/01/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation


class TipController: WKInterfaceController {

    var sourceController: InterfaceController!
    var tip: Int=0
    @IBOutlet weak var tipPercent: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        sourceController = context as? InterfaceController
        tip = sourceController.tipAmount
        displayTip()
    }
    
    // display the current tip value and reset the actual value
    func displayTip(){
        sourceController.tipAmount = tip
        tipPercent.setText("\(tip)%")
    }

    @IBAction func increaseTip() {
        if tip < 100 {
            tip += 1
        }
        displayTip();
    }
    
    @IBAction func decreaseTip() {
        if tip != 0 {
            tip -= 1
        }
        displayTip();
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
