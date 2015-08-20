//
//  ChildWindowController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ChildWindowController: NSWindowController, NSProgressReporting {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    var secondsToRun: Float {
        get {
            let childViewController = self.contentViewController as! ChildViewController
            return childViewController.secondsToRun
        }
        set {
            let childViewController = self.contentViewController as! ChildViewController
            childViewController.secondsToRun = secondsToRun
        }
    }
    
    // MARK: - NSProgressReporting
    
    var progress: NSProgress {
        get {
            let childViewController = self.contentViewController as! ChildViewController
            return childViewController.progress
        }
    }

}
