//
//  BLEServerViewModel.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/16/22.
//

import Foundation
import CoreData


class BLEServerViewModel : BLEViewModel {
    
    let foundServing = true
    
    var bleServer = BLEServer()
    
    func start() {
        bleServer.startServing()
    }
    
    func stop() {
        bleServer.stopServing()
    }
}

