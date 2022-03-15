//
//  BLEServer.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/28/22.
//

import Foundation
import CoreBluetooth
import os

class BLEServer : NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    private var peripheralManager: CBPeripheralManager!
    private var transferCharacteristic: CBMutableCharacteristic?
    
    private let testData = "F4E454F802B88D2F64168FF1742E8CF413FD677D38B87CBEFB45821F8981B912"
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
        peripheralManager.delegate = self
    }
    
    deinit {
        stopServing()
    }
    
    func stopServing(){
        peripheralManager.stopAdvertising()
        os_log("Stop advertising")
    }
    
    func startServing(){
        peripheralManager.startAdvertising( [CBAdvertisementDataServiceUUIDsKey:[BluetoothConstants.DISCOVER_SERVICE]])
        os_log("BLE Server started advertising")
    }
    
    
    private func setUpSever(){
        let service = CBMutableService(type: BluetoothConstants.DISCOVER_SERVICE, primary: true)
        let serverCharacteristic = CBMutableCharacteristic(type: BluetoothConstants.SERVER_CHAR, properties: [ .read], value: testData.data(using: .utf8)!, permissions: [.readable])
        
        let clientCharacteristic = CBMutableCharacteristic(type: BluetoothConstants.CLIENT_CHAR, properties: [ .write], value: nil, permissions: [.writeable])
        
        service.characteristics = [serverCharacteristic, clientCharacteristic]
        peripheralManager.add(service)
        
        os_log("BLE Server set up")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            os_log("Peripheral (Server) is powered on")
            setUpSever()
        case .poweredOff:
            os_log("Peripheral (Server) is not powered on")
        case .resetting:
            os_log("Peripheral (Server) is resetting")
        case .unauthorized:
            os_log("Peripheral (Server) not authorized")
        case .unknown:
            os_log("Peripheral (Server) state is unknown")
        case .unsupported:
            os_log("Peripheral (Server) is not supported on this device")
        @unknown default:
            os_log("A previously unknown Peripheral (Server) manager state occurred")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for aRequest in requests {
            guard let requestValue = aRequest.value, let stringFromData = String(data: requestValue, encoding: .utf8)
            else {
                continue
            }
            os_log("Received write request of %d bytes: %s", requestValue.count , stringFromData )
            
            let bleDevice = BLEDevice(id: UUID(),
                                      name:  "Unknown",
                                      macAddress: aRequest.central.identifier.uuidString,
                                      signalStrenght: "N/A",
                                      lastSeen: Date(),
                                      foundServing: true)
            PersistenceController.addDevice(device: bleDevice)
            
            peripheral.respond(to: aRequest, withResult: .success)
        }
        
    }
}
