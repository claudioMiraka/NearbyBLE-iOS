//
//  BLEClient.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 3/1/22.
//

import Foundation
import CoreBluetooth
import os


class BLEClient : NSObject , ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var bleDevicesList: [BLEDevice] = []
    
    private var centralManager: CBCentralManager!
    
    private var discoveredPeripheral: CBPeripheral?
    private var clientCharacteristic: CBCharacteristic?
    
    private let testData = "2CF24DBA5FB0A30E26E83B2AC5B9E29E1B161E5C1FA7425E73043362938B9824"
    
    override init() {
        
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        centralManager.delegate = self
    }
    
    deinit {
        stopScanning()
    }
    
    func startScanning(){
        retrievePeripheral()
    }
    
    func stopScanning(){
        cleanup()
    }
    
    
    func retrievePeripheral(){
        
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [BluetoothConstants.DISCOVER_SERVICE]))
        
        os_log("Found connected Peripherals with transfer service:  %@", connectedPeripherals)
        
        if let connectedPeripheral = connectedPeripherals.last {
            os_log("Connecting to peripheral %@", connectedPeripheral)
            self.discoveredPeripheral = connectedPeripheral
            centralManager.connect(connectedPeripheral, options: nil)
        } else {
            
            centralManager.scanForPeripherals(withServices: [BluetoothConstants.DISCOVER_SERVICE], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    private func cleanup() {
        // Don't do anything if we're not connected
        guard let discoveredPeripheral = discoveredPeripheral,
              case .connected = discoveredPeripheral.state else { return }
        
        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            os_log("Central (Client) is powered on")
        case .poweredOff:
            os_log("Central (Client) is not powered on")
        case .resetting:
            os_log("Central (Client) is resetting")
        case .unauthorized:
            os_log("Central (Client) is unauthorized")
        case .unknown:
            os_log("Central (Client) state is unknown")
        case .unsupported:
            os_log("Central (Client) is not supported on this device")
        @unknown default:
            os_log("A previously unknown Central (Client) manager state occurred")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        guard RSSI.intValue >= -20 else {
            //os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
            return
        }
        
        os_log("Discovered %s , %d", peripheral.name ?? "Unknown", RSSI.intValue)
        
        if discoveredPeripheral != peripheral {
            discoveredPeripheral = peripheral
            
            os_log("Connecting to perhiperal %@",peripheral)
            centralManager.connect(peripheral, options: nil)
            
            let bleDevice = BLEDevice(id: UUID(), name: peripheral.name ?? "Unknown", macAddress: peripheral.identifier.uuidString, signalStrenght: RSSI.stringValue, lastSeen: Date(), foundServing: false)
            
            PersistenceController.addDevice(device: bleDevice)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
        cleanup()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Peripheral Connected %s, %s, %s ", peripheral.name ?? "" , peripheral.debugDescription, peripheral.description)
        centralManager.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([BluetoothConstants.DISCOVER_SERVICE])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        os_log("Perhiperal Disconnected")
        discoveredPeripheral = nil
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        for service in invalidatedServices where service.uuid == BluetoothConstants.DISCOVER_SERVICE {
            os_log("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([BluetoothConstants.DISCOVER_SERVICE])
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            cleanup()
            return
        }
        
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics([BluetoothConstants.SERVER_CHAR, BluetoothConstants.CLIENT_CHAR ], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == BluetoothConstants.SERVER_CHAR {
            peripheral.readValue(for: characteristic)
            os_log("Read request sent")
        }
        
        for characteristic in serviceCharacteristics {
            if  characteristic.uuid == BluetoothConstants.CLIENT_CHAR {
                clientCharacteristic = characteristic
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let characteristicData = characteristic.value, let stringFromData = String(data: characteristicData, encoding: .utf8) else { return }
        
        os_log("Received %d from bytes: %s", characteristicData.count ,stringFromData )
        
        if characteristic.uuid.uuidString == BluetoothConstants.SERVER_CHAR.uuidString && clientCharacteristic != nil{
            
            os_log("Writing response.")
            peripheral.writeValue(testData.data(using: .utf8)!, for: clientCharacteristic!, type: .withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let error = error {
            os_log("Error in writing characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        if characteristic.uuid.uuidString == BluetoothConstants.CLIENT_CHAR.uuidString{
            os_log("Data written succefully")
            cleanup()
        }
    }
}

