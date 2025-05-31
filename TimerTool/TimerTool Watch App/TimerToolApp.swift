//
//  TimerToolApp.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

@main
struct TimerTool_Watch_AppApp: App {
    
    init() {
        _ = WCSessionManager.shared // Activate session early
        // Initializes the singleton, which activates WCSession in its init. `_ =` avoids unused result warning.
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
