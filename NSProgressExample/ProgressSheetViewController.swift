//
//  ProgressSheetViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

private var progressObservationContext = 0

protocol ProgressSheetInterface {
    var sheetUserInteractive: Bool { get }
    var sheetLabel: String? { get }
}

class ProgressSheetViewController: NSViewController {

    @IBOutlet weak var controlsContainerView: NSStackView!
    @IBOutlet weak var sheetLabel: NSTextField!
    @IBOutlet weak var controlsContainerBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressIndicatorView: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        setupProgressObserver()
    }
    
    deinit {
        if let progressSource = self.presentingViewController {
            progressSource.removeObserver(self, forKeyPath: "progress.fractionCompleted")
        }
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
    
    func setupProgressObserver() {
        if let progressSource = self.presentingViewController {
            progressSource.addObserver(self, forKeyPath: "progress.fractionCompleted", options: [], context: &progressObservationContext)
        }
    }
    
    
    
    // MARK: Key-Value Observing
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &progressObservationContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if let progressSource = self.presentingViewController as? NSProgressReporting {
                self.progressIndicatorView.doubleValue = progressSource.progress.fractionCompleted
            }
        }
    }
    
}
