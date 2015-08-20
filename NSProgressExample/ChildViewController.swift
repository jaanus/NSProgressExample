//
//  ChildViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 14/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ChildViewController: NSViewController, NSProgressReporting, ProgressSheetInterface {

    // NSProgressReporting
    var progress = NSProgress()
    
    var secondsToRun: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        self.performSegueWithIdentifier("presentProgressSheetFromChild", sender: self)
    }
    
    
    // MARK: - ProgressSheetInterface
    
    var sheetUserInteractive: Bool {
        get {
            return false
        }
    }
    
    var sheetLabel: String? {
        get {
            return "Doing child work…"
        }
    }
}
