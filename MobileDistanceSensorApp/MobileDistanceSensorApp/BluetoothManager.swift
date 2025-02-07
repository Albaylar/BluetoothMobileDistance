//
//  BluetoothManager.swift
//  MobileDistanceSensorApp
//
//  Created by Furkan Deniz Albaylar on 7.02.2025.
//

import Foundation
import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var distanceData: String = "No Data"
    
    private var centralManager: CBCentralManager!
    private var sensorPeripheral: CBPeripheral?
    
    // Optionally, specify service and characteristic UUIDs if known.
    // Here we use nil to scan for all devices.
    private let serviceUUID: CBUUID? = nil
    private let characteristicUUID: CBUUID? = nil
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // If serviceUUID is nil, scan for all peripherals.
            centralManager.scanForPeripherals(withServices: serviceUUID != nil ? [serviceUUID!] : nil, options: nil)
            print("Scanning for peripherals...")
        } else {
            print("Bluetooth not available: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown")")
        sensorPeripheral = peripheral
        sensorPeripheral?.delegate = self
        
        // Stop scanning and connect to the first discovered peripheral.
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        // Discover services. If serviceUUID is nil, all services will be discovered.
        peripheral.discoverServices(serviceUUID != nil ? [serviceUUID!] : nil)
    }
    
    // MARK: - CBPeripheralDelegate Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Service discovery error: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            // Discover characteristics. If characteristicUUID is nil, all characteristics will be discovered.
            peripheral.discoverCharacteristics(characteristicUUID != nil ? [characteristicUUID!] : nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let error = error {
            print("Characteristic discovery error: \(error.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            // Subscribe to the characteristic's notifications
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }
        guard let value = characteristic.value else { return }
        // Assuming the Arduino sends the distance as a UTF-8 encoded string.
        if let dataString = String(data: value, encoding: .utf8) {
            DispatchQueue.main.async {
                self.distanceData = dataString
            }
        }
    }
}
