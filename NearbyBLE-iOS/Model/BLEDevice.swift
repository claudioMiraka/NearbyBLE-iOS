//
//  FakeBLEDevice.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/13/22.
//

import Foundation


class BLEDevice : Hashable , Identifiable {
    
    let id : UUID
    let name : String
    let macAddress: String
    let signalStrenght :String
    let lastSeen : Date
    let foundServing : Bool
    
    init(id: UUID,  name: String, macAddress: String, signalStrenght: String, lastSeen: Date, foundServing: Bool ){
        self.id  = id
        self.name = name
        self.macAddress = macAddress
        self.signalStrenght = signalStrenght
        self.lastSeen = lastSeen
        self.foundServing = foundServing
    }
    
    init(bleDeviceLocal : BLEDeviceLocal){
        self.id = bleDeviceLocal.id!
        self.name = bleDeviceLocal.name!
        self.macAddress = bleDeviceLocal.macAddress!
        self.signalStrenght = bleDeviceLocal.signalStrenght!
        self.lastSeen = bleDeviceLocal.lastSeen!
        self.foundServing = bleDeviceLocal.foundServing
    }
    
    static func == (lhs: BLEDevice, rhs: BLEDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}


// MARK: Fake data for preview

var counter = 0

let fakeBLEDevice = BLEDevice(
    id: UUID(),
    name:  "Test Device",
    macAddress: "00:00:00:00:00:00",
    signalStrenght: "N/A",
    lastSeen : Date(),
    foundServing: true
)

let fakeBLEDevicesList = [fakeBLEDevice, fakeBLEDevice, fakeBLEDevice]
