//
//  HeartRateManager.swift
//  Heart rate monitor
//
//  Created by Kevin Chromik on 11/07/16.
//  Copyright © 2016 Kevin Chromik. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol HeartRateManagerDelegate: class {
    func heartRateManager(manager: HeartRateManager, updatedHeartRate heartRate: NSData)
}

class HeartRateManager: NSObject {
    
    static let sharedManager = HeartRateManager()
    weak var delegate: HeartRateManagerDelegate?
    
    private let heartRateSensorUUID = "180D"
    private var manager: CBCentralManager?
    private var heartRateMonitor: CBPeripheral?
    
    
    override init() {
        super.init()
        
        manager = CBCentralManager(delegate: self, queue: nil)
        heartRateMonitor?.delegate = self
    }
    
    func startScan() {
        let services = [CBUUID(string: heartRateSensorUUID)]
        manager?.scanForPeripheralsWithServices(services, options: nil)
    }
    
    private func stopScan() {
        manager?.stopScan()
    }
}

extension HeartRateManager: CBCentralManagerDelegate {
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        heartRateMonitor = peripheral
        heartRateMonitor?.delegate = self
        manager?.connectPeripheral(heartRateMonitor!, options: nil)
    }
    
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("")
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("")
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("")
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("")
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("")
    }
    
}

extension HeartRateManager: CBPeripheralDelegate {
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
        print("")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for characteristic in service.characteristics! {
            print(characteristic.UUID)
            if characteristic.UUID.UUIDString == "2A37" {
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let updateValue = characteristic.value where characteristic.UUID.isEqual(CBUUID(string: "2A37")) {
            delegate?.heartRateManager(self, updatedHeartRate: updateValue)
        }
    }
    
}