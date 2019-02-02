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


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    var tipAmount: Int = 10
    var splitBetween: Int = 1
    var billTotal = Double(0)
    var focusButton: Int = 0

    @IBOutlet var currentSplit: WKInterfaceLabel!
    @IBOutlet var currentTip: WKInterfaceLabel!
    @IBOutlet weak var billButton: WKInterfaceButton!
    @IBOutlet weak var currentTotal: WKInterfaceLabel!
    @IBOutlet weak var costEach: WKInterfaceLabel!
    @IBOutlet weak var withTip: WKInterfaceLabel!
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // This will be called when the activation of a session finishes.
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
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
        updateCalc()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func splitDecrease() {
        if(splitBetween > 1){
            splitBetween -= 1
        }
        updateCalc()
    }
    
    @IBAction func splitIncrease() {
        if(splitBetween < 99){
            splitBetween += 1
        }
        updateCalc()
    }
    
    @IBAction func tipPercentReduce() {
        if(tipAmount>0){
            tipAmount -= 1
        }
        updateCalc()
    }
    
    @IBAction func tipPercentIncrease() {
        if(tipAmount<100){
            tipAmount += 1
        }
        updateCalc()
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
        currentTip.setText("\(tipAmount)%")
        currentSplit.setText("\(splitBetween)")
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
