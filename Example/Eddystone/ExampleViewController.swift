//
//  ExampleViewController.swift
//  Eddystone
//
//  Created by Tanner Nelson on 07/24/2015.
//  Copyright (c) 2015 Tanner Nelson. All rights reserved.
//

import UIKit
import Eddystone

class ExampleViewController: UIViewController {

    //MARK: Interface
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK: Properties
    var urls = Eddystone.Scanner.urls()
    var previousUrls: [Eddystone.Url] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Eddystone.Scanner.start(self)
        
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = 100
    }

}

extension ExampleViewController: Eddystone.ScannerDelegate {
    
    func eddystoneUrlsDidChange() {
        
        self.previousUrls = self.urls
        self.urls = Eddystone.Scanner.urls()
        
        self.mainTableView.switchDataSourceFrom(self.previousUrls, to: self.urls, withAnimation: .Top)
    }
    
}


extension ExampleViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExampleTableViewCell") as! ExampleTableViewCell
        
        var url = self.urls[indexPath.row]
        
        cell.mainLabel.text = url.url.absoluteString
        
        
        switch url.signalStrength {
        case .Excellent: cell.signalStrengthView.signal = .Excellent
        case .VeryGood: cell.signalStrengthView.signal = .VeryGood
        case .Good: cell.signalStrengthView.signal = .Good
        case .Low: cell.signalStrengthView.signal = .Low
        case .VeryLow: cell.signalStrengthView.signal = .VeryLow
        case .NoSignal: cell.signalStrengthView.signal = .NoSignal
        default: cell.signalStrengthView.signal = .Unknown
        }
    
        return cell
    }
    
}

extension ExampleViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}