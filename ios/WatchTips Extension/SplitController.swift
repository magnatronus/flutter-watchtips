//
//  SplitController.swift
//  WatchTips Extension
//
//  Created by Stephen Rogers on 28/01/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation


class SplitController: WKInterfaceController {

    
    @IBOutlet weak var splitBetween: WKInterfaceLabel!
    var split: Int = 1
    var sourceController: InterfaceController!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        sourceController = context as? InterfaceController
        split = sourceController.splitBetween
        updateSplit()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // update the slit display and the bill split
    func updateSplit(){
        sourceController.splitBetween = split
        splitBetween.setText("\(split)")
    }

    @IBAction func increaseSplit() {
        if split < 50 {
            split += 1
            updateSplit()
        }
    }
    
    
    @IBAction func decreaseSplit() {
        if split > 1 {
            split -= 1
            updateSplit()
        }
    }
    
    
}
