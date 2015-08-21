//
//  Task.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 21/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Foundation

/** A long-running task that reports its progress with NSProgress.

It internally uses the pausing, resume and cancellation handler blocks, so don’t set those on the NSProgress object. If you need to observe the progress or properties, use KVO.
*/
class Task: NSObject, NSProgressReporting {
    
    let progress: NSProgress
    private let iterationCount: Int64
    private let iterationLength = Float(0.05)
    
    init(duration: Float) {
        iterationCount = Int64(duration / iterationLength)
        progress = NSProgress(totalUnitCount: iterationCount)

        super.init()
        
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
        // Verify that the task is correctly released.
        // print("Task is going away.")
    }
}
