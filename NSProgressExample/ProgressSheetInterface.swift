//
//  ProgressSheetInterface.swift
//  NSProgressExample
//
//  Created by Jaanus Kase on 20/08/15.
//  Copyright © 2015 Jaanus Kase. All rights reserved.
//

import Foundation

protocol ProgressSheetInterface {
    var sheetUserInteractive: Bool { get }
    var sheetLabel: String? { get }
}
