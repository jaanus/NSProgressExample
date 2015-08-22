//
//  Task.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 21/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Foundation



private var progressObservationContext = 0



/// A long-running task that reports its progress with NSProgress. Is pausable/resumable and cancellable.
class Task: NSObject, NSProgressReporting {
    
    let progress: NSProgress
    private let iterationCount: Int64
    private let iterationLength = Float(0.05)
    
    init(duration: Float) {
        iterationCount = Int64(duration / iterationLength)
        progress = NSProgress(totalUnitCount: iterationCount)
        progress.cancellable = true
        progress.pausable = true
        
        super.init()

        progress.addObserver(self, forKeyPath: "paused", options: [], context: &progressObservationContext)
        
        runTask()
        
    }
    
    /// Run or continue the task.
    private func runTask() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            for var i : Int64 = self.progress.completedUnitCount; i < self.iterationCount; i++ {
                guard !self.progress.cancelled else { return }
                guard !self.progress.paused else { return }
                
                NSThread.sleepForTimeInterval(NSTimeInterval(self.iterationLength))
                
                self.progress.completedUnitCount++
            }
        }
    }
    
    deinit {
        progress.removeObserver(self, forKeyPath: "paused")
        
        // Verify that the task is correctly released.
        // print("Task is going away.")
    }
    
    
    
    // Mark: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &progressObservationContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        if let progress = object as? NSProgress {
            if keyPath == "paused" {
                if !progress.paused {
                    // When the progress goes from “paused” to “resumed” state, continue running the task.
                    runTask()
                }
            }
        }
    }
}
