//
//  ViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 14/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var worker1, worker2: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func start(sender: AnyObject) {
        
        worker1 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
        worker1!.showWindow(self)

        worker2 = self.storyboard?.instantiateControllerWithIdentifier("Worker") as? NSWindowController
        worker2!.showWindow(self)

    }

}

