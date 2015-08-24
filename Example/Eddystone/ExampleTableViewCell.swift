//
//  ExampleTableViewCell.swift
//  Eddystone
//
//  Created by Tanner Nelson on 7/24/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import SignalStrength

class ExampleTableViewCell: UITableViewCell {

    //MARK: Interface
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var signalStrengthView: SignalStrengthView!
    
}
