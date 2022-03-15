//
//  BLEDeviceTile.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/12/22.
//

import SwiftUI

struct BLEDeviceTile: View {
    
    let bleDevice : BLEDevice
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 10.0) {
            VStack (alignment: .leading, spacing: 10.0) {
                Text(bleDevice.name)
                Text(bleDevice.macAddress).fontWeight(.light)
            }
            Spacer()
            VStack (alignment: .trailing, spacing: 10.0){
                Text(bleDevice.signalStrenght)
                Text("\(bleDevice.lastSeen, formatter: itemFormatter)").fontWeight(.light) .foregroundColor(.gray)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

struct BLEDeviceTile_Previews: PreviewProvider {
    static var previews: some View {
        BLEDeviceTile(bleDevice: fakeBLEDevice)
    }
}
