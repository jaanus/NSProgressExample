//
//  ViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 14/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSProgressReporting, ProgressSheetInterface {

    // Use progress reporting because the sheet asks for our progress
    var progress = NSProgress()
    
    var worker1, worker2: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        worker1 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
        worker2 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func start(sender: AnyObject) {
        fixWindowPositions()
        worker1?.showWindow(self)
        worker2?.showWindow(self)
        
        performSegueWithIdentifier("presentProgressSheet", sender: self)
    }
    
    func fixWindowPositions() {
        let myFrame = self.view.window?.frame as NSRect!
        
        let x = CGRectGetMaxX(myFrame!) + 32
        let y = CGRectGetMaxY(myFrame!)
        
        worker1?.window?.setFrameTopLeftPoint(NSPoint(x: x, y: y))

        let y2 = CGRectGetMinY((worker1!.window?.frame)!) - 32
        worker2?.window?.setFrameTopLeftPoint(NSPoint(x: x, y: y2))
        
//        CGFloat x = CGRectGetMaxX(self.window.frame) + 32;
//        CGFloat y = CGRectGetMaxY(self.window.frame);
//        [self.worker1.window setFrameTopLeftPoint:NSMakePoint(x, y)];
//        
//        CGFloat y2 = CGRectGetMinY(self.worker1.window.frame) - 32;
//        [self.worker2.window setFrameTopLeftPoint:NSMakePoint(x, y2)];
    }
    
    
    
    // MARK: - ProgressSheetInterface
    
    var sheetUserInteractive: Bool {
        get {
            return true
        }
    }
    
    var sheetLabel: String? {
        get {
            return nil
        }
    }
    
}
