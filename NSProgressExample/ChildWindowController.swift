//
//  ChildWindowController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ChildWindowController: NSWindowController, ChildTaskInterface {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    // MARK: - ChildTaskInterface
    
    func startTaskWithDuration(duration: Float) {
        let childViewController = self.contentViewController as! ChildTaskInterface
        childViewController.startTaskWithDuration(duration)
    }
    
    var progress: NSProgress {
        get {
            let childViewController = self.contentViewController as! ChildTaskInterface
            return childViewController.progress
        }
    }

}
