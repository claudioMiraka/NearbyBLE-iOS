//
//  ContentView.swift
//  NearbyBLE-iOS
//
//  Created by Claudio Miraka on 2/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    private enum Tab {
        case BLEServer
        case BLEClient
    }
    
    @State private var selection : Tab = .BLEServer
    
    var body: some View {
        TabView(selection: $selection) {
            
            BLEDevicesWidget( bleViewModel: BLEServerViewModel())
                .tabItem {
                    Label("Server", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(Tab.BLEServer)
            
            BLEDevicesWidget(bleViewModel: BLEClientViewModel())
                .tabItem {
                    Label("Client", systemImage: "move.3d")
                }
                .tag(Tab.BLEClient)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

