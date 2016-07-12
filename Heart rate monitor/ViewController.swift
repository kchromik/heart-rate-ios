//
//  ViewController.swift
//  Heart rate monitor
//
//  Created by Kevin Chromik on 11/07/16.
//  Copyright © 2016 Kevin Chromik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentHeartRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeartRateManager.sharedManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        currentHeartRateLabel.text = "Current HR: \(currentHeartRate)"
    }
}