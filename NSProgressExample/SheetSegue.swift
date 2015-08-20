//
//  SheetSegue.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class SheetSegue: NSStoryboardSegue {
    override func perform() {
        let source = self.sourceController as! NSViewController
        let destination = self.destinationController as! NSWindowController
        
        source.view.window?.beginSheet(destination.window!, completionHandler: nil)
    }
}
