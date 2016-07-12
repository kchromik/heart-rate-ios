//
//  ViewController.swift
//  Heart rate monitor
//
//  Created by Kevin Chromik on 11/07/16.
//  Copyright © 2016 Kevin Chromik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var heartRateValues = [HeartRateSample]()
    @IBOutlet weak var tableView: UITableView!
    
    private struct HeartRateSample {
        var timeStamp: NSDate
        var heartRateValue: UInt8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeartRateManager.sharedManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func searchDevicesPressed(sender: UIButton) {
        HeartRateManager.sharedManager.startScan()
    }
}


extension ViewController: HeartRateManagerDelegate {
    // http://stackoverflow.com/questions/25456359/how-to-get-data-out-of-bluetooth-characteristic-in-swift
    func heartRateManager(manager: HeartRateManager, updatedHeartRate heartRate: NSData) {
        let data = heartRate
        var values = [UInt8](count:data.length, repeatedValue:0)
        data.getBytes(&values, length:data.length)
        
        let currentHeartRate = values[1]
        heartRateValues.append(HeartRateSample(timeStamp: NSDate(), heartRateValue: currentHeartRate))
        tableView.reloadData()
        
        let path = NSIndexPath(forRow: tableView.numberOfRowsInSection(0) - 1, inSection: 0)
        tableView.scrollToRowAtIndexPath(path, atScrollPosition: .Bottom, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heartRateValues.count
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("heartRateCell")
        cell?.textLabel!.text = "\(indexPath.row):\t\(heartRateValues[indexPath.row].heartRateValue)\t\(heartRateValues[indexPath.row].timeStamp)"
        return cell!
    }
    
}