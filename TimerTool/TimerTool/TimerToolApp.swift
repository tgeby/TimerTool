//
//  TimerToolApp.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

@main
struct TimerToolApp: App {
    
    init() {
        WCSessionManager.shared // Activate session early
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
