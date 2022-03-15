//
//  BLEConstants.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 3/1/22.
//

import Foundation
import CoreBluetooth

struct BluetoothConstants {
    
    static let  MTU_PREFERRED_SIZE = 256
    
    static let DISCOVER_SERVICE = CBUUID.init(string:"074169d4-ff2b-4d93-b19e-fc24a8f989b8")
    
    static let SERVER_CHAR = CBUUID.init(string:"8c7bfc94-028d-47fc-9457-a31fd3c13799")
       
    static var CLIENT_CHAR = CBUUID.init(string:"5691dc94-f624-4ed8-acd1-819477eedbb1")
    
}

