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
        WCSessionManager.shared // Activate session early
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
