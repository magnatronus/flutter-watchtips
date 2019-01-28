//
//  BillController.swift
//  WatchTips Extension
//
//  Created by Stephen Rogers on 28/01/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation


class BillController: WKInterfaceController {

    
    var billValue = "0"
    var decimalAdded = false
    var sourceController: InterfaceController!
    @IBOutlet weak var totalAmount: WKInterfaceLabel!
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        sourceController = context as? InterfaceController
        if sourceController.billTotal != 0.0 {
            billValue = "\(sourceController.billTotal)"
        } else {
            billValue = "0"
        }
        displayBillValue()
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // Clear
    @IBAction func clearBtn() {
        billValue.remove(at: billValue.index(before: billValue.endIndex))
        if billValue.count == 0 {
            billValue = "0"
        }
        displayBillValue()
    }
    
    
    @IBAction func decimalBtn() {
        appendDecimal()
    }
    
    
    @IBAction func zeroBtn() {
        appendValue(value: 0)
    }
    
    
    @IBAction func oneBtn() {
        appendValue(value: 1)
    }
    
    
    @IBAction func twoBtn() {
        appendValue(value: 2)
    }
    
    @IBAction func threeBtn() {
        appendValue(value: 3)
    }
    
    
    @IBAction func fourBtn() {
        appendValue(value: 4)
    }
    
    
    @IBAction func fiveBtn() {
        appendValue(value: 5)
    }
    
    
    @IBAction func sixBtn() {
        appendValue(value: 6)
    }
    
    
    @IBAction func sevenBtn() {
        appendValue(value: 7)
    }
    
    
    @IBAction func eightBtn() {
        appendValue(value: 8)
    }
    
    @IBAction func nineBtn() {
        appendValue(value: 9)
    }
    
    // display the bill value and update amount in source controller
    func displayBillValue(){
        if let _ = billValue.index(of: (".")) {
            decimalAdded = true
        } else {
            decimalAdded = false
        }
        totalAmount.setText(billValue)
        sourceController.billTotal = Double(billValue)!
    }
    
    // Append an amount to the displayed bill
    func appendValue(value: Int){
        
        let stringValue = "\(value)"
        if(billValue == "0"){
            billValue = stringValue
        } else {
            billValue  = billValue +  stringValue
        }
        displayBillValue()
    }
    
    // only add decimal if not already added
    func appendDecimal(){
        
        // did we have a decimal?
        if !decimalAdded {
            billValue  = billValue +  "."
        }
        
        // display total
        displayBillValue()
        
        
    }

}
