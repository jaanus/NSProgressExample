//
//  ProgressSheetViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

class ProgressSheetViewController: NSViewController {

    @IBOutlet weak var controlsContainerView: NSStackView!
    @IBOutlet weak var sheetLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let progressSource = self.presentingViewController as! NSProgressReporting
        setupInterface()
    }

    func setupInterface() {
        let interfaceSource = self.presentingViewController as! ProgressSheetInterface
        if !interfaceSource.sheetUserInteractive {
            controlsContainerView.hidden = true
        }
        if let interfaceLabel = interfaceSource.sheetLabel {
            sheetLabel.stringValue = interfaceLabel
        }
    }
    
}
