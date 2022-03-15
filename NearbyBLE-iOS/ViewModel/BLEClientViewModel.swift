//
//  BLEClientViewModel.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/14/22.
//

import Foundation
import CoreData
import os


class BLEClientViewModel : BLEViewModel {
    
    let foundServing = false
    
    let bleClient = BLEClient()
    
    func start() {
        bleClient.startScanning()
    }
    
    func stop() {
        bleClient.stopScanning()
    }
}
