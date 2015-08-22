//
//  ViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 14/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa



private var progressObservationContext = 0



class ViewController: NSViewController, ProgressSheetInterface, ProgressSheetDelegate {

    // Use progress reporting because the sheet asks for our progress
    var progress = NSProgress()
    
    var worker1, worker2: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        worker1 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
        worker2 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
    }

    @IBAction func start(sender: AnyObject) {
        fixWindowPositions()
        worker1?.showWindow(self)
        worker2?.showWindow(self)
        
        if let worker1 = worker1 as? ChildTaskInterface, worker2 = worker2 as? ChildTaskInterface {

            progress = NSProgress(totalUnitCount: 10)
            
            progress.addObserver(self, forKeyPath: "completedUnitCount", options: [], context: &progressObservationContext)
            progress.addObserver(self, forKeyPath: "cancelled", options: [], context: &progressObservationContext)
            
            worker1.startTaskWithDuration(3)
            worker2.startTaskWithDuration(14)
            
            progress.addChild(worker1.progress, withPendingUnitCount: 1)
            progress.addChild(worker2.progress, withPendingUnitCount: 9)
            
        }
        
        // Present the progress sheet with action buttons.
        performSegueWithIdentifier("presentProgressSheet", sender: self)
    }

    
    
    // MARK: - ProgressSheetInterface
    
    var sheetIsUserInteractive: Bool {
        get {
            return true
        }
    }
    
    var sheetLabel: String? {
        get {
            return nil
        }
    }
    
    
    
    // MARK: - ProgressSheetDelegate
    
    func cancel() {
        progress.cancel()
    }
    
    func pause() {
        progress.pause()
    }
    
    func resume() {
        progress.resume()
    }
    
    
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &progressObservationContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        if let progress = object as? NSProgress {
            if keyPath == "completedUnitCount" {
                if progress.completedUnitCount >= progress.totalUnitCount {
                    // Work is done.
                    self.tasksFinished()
                }
            } else if keyPath == "cancelled" {
                if progress.cancelled {
                    self.tasksFinished()
                }
            }
        }
    }
    
    
    
    // MARK: - Utilities
    
    
    func fixWindowPositions() {
        let myWindowFrame = self.view.window?.frame as NSRect!
        
        let x = CGRectGetMaxX(myWindowFrame!) + 32
        let y = CGRectGetMaxY(myWindowFrame!)
        
        worker1?.window?.setFrameTopLeftPoint(NSPoint(x: x, y: y))
        
        let y2 = CGRectGetMinY((worker1!.window?.frame)!) - 32
        worker2?.window?.setFrameTopLeftPoint(NSPoint(x: x, y: y2))
    }
    
    func tasksFinished() {
        
        progress.removeObserver(self, forKeyPath: "cancelled")
        progress.removeObserver(self, forKeyPath: "completedUnitCount")
        
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.dismissViewController((self?.presentedViewControllers?.first)!)
       }
 
    }
}
