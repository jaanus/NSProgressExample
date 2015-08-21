//
//  ProgressSheetViewController.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Cocoa

private var progressObservationContext = 0

protocol ProgressSheetInterface: NSProgressReporting {
    var sheetUserInteractive: Bool { get }
    var sheetLabel: String? { get }
}

protocol ProgressSheetDelegate {
    func cancel()
    func pause()
    func resume()
}

class ProgressSheetViewController: NSViewController {

    @IBOutlet weak var controlsContainerView: NSStackView!
    @IBOutlet weak var sheetLabel: NSTextField!
    @IBOutlet weak var controlsContainerBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressIndicatorView: NSProgressIndicator!
    @IBOutlet weak var pauseOrResumeButton: NSButton!
    
    private var paused = false {
        didSet {
            if paused {
                self.pauseOrResumeButton.title = "Resume"
            } else {
                self.pauseOrResumeButton.title = "Pause"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        setupProgressObserver()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if let progressSource = self.presentingViewController as? ProgressSheetInterface {
            progressSource.progress.removeObserver(self, forKeyPath: "fractionCompleted")
            progressSource.progress.removeObserver(self, forKeyPath: "completedUnitCount")
        }
        
    }
    
    deinit {
        if let progressSource = self.presentingViewController as? ProgressSheetInterface {
//            progressSource.progress.removeObserver(self, forKeyPath: "fractionCompleted")
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
        if let progressSource = self.presentingViewController as? ProgressSheetInterface {
            progressSource.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [], context: &progressObservationContext)
            progressSource.progress.addObserver(self, forKeyPath: "completedUnitCount", options: [], context: &progressObservationContext)
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        if let delegate = self.presentingViewController as? ProgressSheetDelegate {
            delegate.cancel()
        }
    }
    
    @IBAction func pauseOrResume(sender: AnyObject) {
        paused = !paused
        if let delegate = self.presentingViewController as? ProgressSheetDelegate {
            if paused {
                delegate.pause()
            } else {
                delegate.resume()
            }
        }
    }
    
    
    
    // MARK: - Key-Value Observing
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &progressObservationContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
//        dispatch_sync(dispatch_get_main_queue()) {
        
            if let progress = object as? NSProgress {
                if keyPath == "fractionCompleted" {
                    dispatch_async(dispatch_get_main_queue()) {
                        [weak self] in
                        self?.progressIndicatorView.doubleValue = progress.fractionCompleted
                        
                    }
                } else if keyPath == "completedUnitCount" {
                    if progress.completedUnitCount >= progress.totalUnitCount {
                        // We are done with this indicator. Remove the observer.
                        
                        
                    }
                }
            }

            
//        }
    }
    
}
