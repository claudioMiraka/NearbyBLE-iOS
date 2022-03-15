//
//  BLEDevicesWidget.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/13/22.
//

import SwiftUI

struct BLEDevicesWidget: View {
    
    let bleViewModel : BLEViewModel
    
    @Environment(\.managedObjectContext)private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BLEDeviceLocal.lastSeen, ascending: false)],
        animation: .default
    )
    private var devices: FetchedResults<BLEDeviceLocal>
    
    
    var body: some View {
        ScrollView{
            HStack {
                Button {
                    
                    for device in devices where device.foundServing == bleViewModel.foundServing {
                        viewContext.delete(device)
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    
                } label: {
                    Text("Clear")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                }
                Spacer()
                Button {
                    bleViewModel.stop()
                } label: {
                    Text("Stop").padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                }
                Spacer()
                Button {
                    bleViewModel.start()
                } label: {
                    Text("Start").padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                        )
                }
            }.padding()
            if(devices.filter { $0.foundServing == bleViewModel.foundServing }.count > 0){
                VStack (alignment: HorizontalAlignment.center, spacing: 10){
                    ForEach (devices.filter { $0.foundServing == bleViewModel.foundServing }) { device in
        
                        BLEDeviceTile(bleDevice: BLEDevice(bleDeviceLocal: device))
                            .onTapGesture {
                                viewContext.delete(device)
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        
                    }
                }.padding()
            } else{
                Text("Empty")
            }
        }
    }
}


struct BLEDevicesWidget_Previews: PreviewProvider {
    static var previews: some View {
        BLEDevicesWidget(bleViewModel: BLEClientViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
