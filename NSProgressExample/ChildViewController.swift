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

private var progressObservationContext = 0

class ChildViewController: NSViewController, ChildTaskInterface, ProgressSheetInterface {

    @IBOutlet weak var statusLabel: NSTextField!
    
    var task: Task?
    
    // NSProgressReporting
    var progress: NSProgress {
        get {
            if let progress = task?.progress {
                return progress
            }
            fatalError("Requesting child progress before it is available")
        }
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

    
    
    // MARK: - ChildTaskInterface
    
    func startTaskWithDuration(taskDuration: Float) {
        
        task = Task(duration: taskDuration)
        task?.progress.cancellationHandler = {
            self.taskFinished(cancelled: true)
        }
        
        // Should perform this segue only after the new progress property has created,
        // so that the progress sheet would be observing the right progress object
        self.performSegueWithIdentifier("presentProgressSheetFromChild", sender: self)
        
        self.task?.progress.addObserver(self, forKeyPath: "completedUnitCount", options: [], context: &progressObservationContext)
    }
    
    
    
    // MARK: - Private utilities
    
    private func taskFinished(cancelled cancelled: Bool) {
        
        // Can’t guarantee the queue where this arrives, so dispatch to main to be safe.
        
        dispatch_async(dispatch_get_main_queue()) {
            
            [weak self] in
            
            // In any case, if the task is done, we shouldn’t observe its progress any more
            self?.task?.progress.removeObserver(self!, forKeyPath: "completedUnitCount")
            
            // Not sure how to efficiently reverse-segue in Cocoa, so let’s just do it the hardcoded way.
            // This assumes that the only possible presented sheet is the progress sheet.
            self?.dismissViewController((self?.presentedViewControllers?.first)!)
            
            self?.task = nil
            
            if cancelled {
                self?.statusLabel.stringValue = "The task was cancelled."
            } else {
                self?.statusLabel.stringValue = "The answer is 42."
            }
        }
        
    }
    
    
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &progressObservationContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }

        if let progress = object as? NSProgress {
            if progress.completedUnitCount >= progress.totalUnitCount {
                // work is done.
                self.taskFinished(cancelled: false)
            }
        }
    }
}
