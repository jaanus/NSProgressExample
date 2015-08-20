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
        
        delay(2, closure: {
            print("oh hai")
            // Not sure how to efficiently reverse-segue in Cocoa, so let’s just do it the hardcoded way.
            // This assumes that the only possible presented sheet is the progress sheet.
            self.dismissViewController((self.presentedViewControllers?.first)!)
        })
        
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
