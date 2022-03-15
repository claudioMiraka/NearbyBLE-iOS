//
//  BLEViewModel.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/16/22.
//

import Foundation

protocol BLEViewModel {
    
    var foundServing : Bool { get }
     
    func start()
    
    func stop()

}
