//
//  Persistence.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/12/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for _ in 0..<10 {
            
            let newDevice = BLEDeviceLocal(context: viewContext)
            newDevice.id  = UUID()
            newDevice.name = fakeBLEDevice.name
            newDevice.macAddress = fakeBLEDevice.macAddress
            newDevice.signalStrenght = fakeBLEDevice.signalStrenght
            newDevice.lastSeen = fakeBLEDevice.lastSeen
            newDevice.foundServing = true
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NearbyBLE_iOS")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static func addDevice(device: BLEDevice) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let newDevice = BLEDeviceLocal(context: viewContext)
        newDevice.id  = device.id
        newDevice.name = device.name
        newDevice.macAddress = device.macAddress
        newDevice.signalStrenght = device.signalStrenght
        newDevice.lastSeen = device.lastSeen
        newDevice.foundServing = device.foundServing
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

