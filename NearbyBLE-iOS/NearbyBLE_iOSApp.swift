//
//  NearbyBLE_iOSApp.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/12/22.
//

import SwiftUI

@main
struct NearbyBLE_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
