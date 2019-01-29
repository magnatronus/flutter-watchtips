//
//  InterfaceController.swift
//  WatchTips Extension
//
//  Created by Stephen Rogers on 27/01/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate, WKCrownDelegate {
    
    
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
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // This will be called when the activation of a session finishes.
    }
    
    
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        accumulatedCrownDelta = 0.0
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        accumulatedCrownDelta += rotationalDelta
        let threshold = 0.05
        
        // do nothing if delta is less that threshold
        guard abs(accumulatedCrownDelta) > threshold else {
            return
        }
        
        if focusButton == 1 {
            if accumulatedCrownDelta > 0 {
                splitBetween += 1
            } else {
                splitBetween -= 1
            }
            if splitBetween < 1 {
                splitBetween = 1
            }
            if splitBetween > 50 {
                splitBetween = 50
            }
        }
        
        if focusButton == 2 {
            if accumulatedCrownDelta > 0 {
                tipAmount += 1
            } else {
                tipAmount -= 1
            }
            if tipAmount < 0 {
                tipAmount = 0
            }
            if tipAmount > 100 {
                tipAmount = 100
            }
        }
        
        accumulatedCrownDelta = 0
        updateCalc()
        
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
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        crownSequencer.focus()
        updateCalc()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // chnage how many the bill is split between
    @IBAction func showSplitController() {
        resetButtonFocus()
        currentSplit?.setBackgroundColor(UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0))
        focusButton = 1
        presentController(withName: "SplitController", context: self)
    }
    
    
    @IBAction func showTipController() {
        resetButtonFocus()
        currentTip?.setBackgroundColor(UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0))
        focusButton = 2
        presentController(withName: "TipController", context: self)
    }
    
    
    @IBAction func showBillController() {
        resetButtonFocus()
        presentController(withName: "BillController", context: self)
    }
    
    // reset the focus to the currently selected button
    func resetButtonFocus(){
        focusButton = 0
        currentSplit?.setBackgroundColor(UIColor.darkGray)
        currentTip?.setBackgroundColor(UIColor.darkGray)
        billButton?.setBackgroundColor(UIColor.darkGray)
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
        if WCSession.isSupported() {
            let session = WCSession.default
            let calcInfo = [
                "tip":"\(tipAmount)",
                "split": "\(splitBetween)",
                "bill": "\(billTotal)"
                ] as [String : Any];
            session.transferUserInfo(calcInfo)
        }
    }
    

}
