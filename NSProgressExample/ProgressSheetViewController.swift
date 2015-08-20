//
//  ProgressSheetViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

protocol ProgressSheetInterface {
    var sheetUserInteractive: Bool { get }
    var sheetLabel: String? { get }
}

class ProgressSheetViewController: NSViewController {

    @IBOutlet weak var controlsContainerView: NSStackView!
    @IBOutlet weak var sheetLabel: NSTextField!
    @IBOutlet weak var controlsContainerBottomMarginConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let progressSource = self.presentingViewController as! NSProgressReporting
        setupInterface()
    }

    func setupInterface() {
        if let interfaceSource = self.presentingViewController as? ProgressSheetInterface {
            if !interfaceSource.sheetUserInteractive {
                // if the buttons are not to be shown, hide them,
                // and also deactivate the constraint that is holding them in place,
                // so that the bottom margin of the progress bar kicks in
                // to constrain the sheet height.
                controlsContainerView.hidden = true
                controlsContainerBottomMarginConstraint.active = false
            }
            if let interfaceLabel = interfaceSource.sheetLabel {
                sheetLabel.stringValue = interfaceLabel
            }
            
        }
    }
    
}
