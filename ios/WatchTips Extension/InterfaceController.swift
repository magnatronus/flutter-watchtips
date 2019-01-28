//
//  InterfaceController.swift
//  WatchTips Extension
//
//  Created by Stephen Rogers on 27/01/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    
    var tipAmount: Int = 10
    var splitBetween: Int = 1
    var billTotal = Double(0)
    var focusButton: Int = 0
    var accumulatedCrownDelta = 0.0

    @IBOutlet weak var currentSplit: WKInterfaceButton!
    @IBOutlet weak var currentTip: WKInterfaceButton!
    @IBOutlet weak var billButton: WKInterfaceButton!
    @IBOutlet weak var currentTotal: WKInterfaceLabel!
    @IBOutlet weak var costEach: WKInterfaceLabel!
    @IBOutlet weak var withTip: WKInterfaceLabel!
    
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        accumulatedCrownDelta = 0.0
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        accumulatedCrownDelta += rotationalDelta
        //let threshoold = 0.5
        
        
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        crownSequencer.delegate = self
        updateCalc()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        crownSequencer.focus()
        updateCalc()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // chnage how many the bill is split between
    @IBAction func showSplitController() {
        presentController(withName: "SplitController", context: self)
    }
    
    
    @IBAction func showTipController() {
        presentController(withName: "TipController", context: self)
    }
    
    
    @IBAction func showBillController() {
        presentController(withName: "BillController", context: self)
    }
    
    // Update the actual calculations
    func updateCalc(){
        
        // do bill calculations
        let tip = (billTotal/100) * Double(tipAmount)
        let billWithTip = billTotal + tip
        let perPerson = billWithTip / Double(splitBetween)
        
        // update display
        currentTip.setTitle("\(tipAmount)%")
        currentSplit.setTitle("\(splitBetween)")
        currentTotal.setText(String(format: "%.2f", billTotal))
        withTip.setText(String(format: "%.2f", billWithTip))
        costEach.setText(String(format: "%.2f", perPerson))
        
        // now see if we can sent the calc data back to the app
        //if WCSession.isSupported() {
        //    let session = WCSession.default()
        //    let calcInfo = [
        //        "tip":"\(tipAmount)",
        //        "split": "\(splitBetween)",
        //        "bill": "\(billTotal)"
        //        ] as [String : Any];
        //    session.transferUserInfo(calcInfo)
        //}
    }
    

}
