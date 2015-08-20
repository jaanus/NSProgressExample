//
//  ChildViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 14/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

protocol ChildTaskInterface: NSProgressReporting {
    func startTaskWithDuration(duration: Float)
}

// Why do I have to explicitly add NSProgressReporting here? ChildTaskInterface should cover it, no?
class ChildViewController: NSViewController, ChildTaskInterface, ProgressSheetInterface, NSProgressReporting {

    @IBOutlet weak var statusLabel: NSTextField!
    
    // NSProgressReporting
    var progress = NSProgress()
    
    var secondsToRun: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        
//        longComputationTask()
        
        delay(2, closure: {
            print("oh hai")

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
    
    func startTaskWithDuration(taskDuration: Float) {
        let iterationLength = Float(0.05)
        let iterationCount: Int64 = Int64(taskDuration / iterationLength)
        
        progress = NSProgress(totalUnitCount: iterationCount)

        // Should perform this segue only after the new progress property has created,
        // so that the progress sheet would be observing the right progress object
        self.performSegueWithIdentifier("presentProgressSheetFromChild", sender: self)

        
        progress.cancellationHandler = {
            self.taskFinished(cancelled: true)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            for var i : Int64 = self.progress.completedUnitCount; i < iterationCount; i++ {
                guard !self.progress.cancelled else { return }
                guard !self.progress.paused else { return }
                
                NSThread.sleepForTimeInterval(NSTimeInterval(iterationLength))
                
                self.progress.completedUnitCount++
            }
            
            self.progress.cancellationHandler = nil
            self.taskFinished(cancelled: false)

        }
        
    }
    
    func taskFinished(cancelled cancelled: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            
            // Not sure how to efficiently reverse-segue in Cocoa, so let’s just do it the hardcoded way.
            // This assumes that the only possible presented sheet is the progress sheet.
            self.dismissViewController((self.presentedViewControllers?.first)!)
            
            if cancelled {
                self.statusLabel.stringValue = "The task was cancelled."
            } else {
                self.statusLabel.stringValue = "The answer is 42."
            }
            
        }
    }
}
