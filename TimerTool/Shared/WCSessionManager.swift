//
//  WCSessionManager.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/31/25.
//

import Foundation
import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate {
    static let shared = WCSessionManager()

    override private init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // Optional: Check activation state
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated: \(activationState.rawValue)")
    }

    // Required on iPhone for Watch pairing support
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate() // Re-activate if deactivated
    }
    #endif

    // Handle incoming data
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["intervalsData"] as? Data,
           let decoded = try? JSONDecoder().decode([IntervalSequence].self, from: data) {
            SharedIntervalManager.shared.saveIntervalSequences(decoded)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        if let data = userInfo["intervalsData"] as? Data,
           let decoded = try? JSONDecoder().decode([IntervalSequence].self, from: data) {
            SharedIntervalManager.shared.saveIntervalSequences(decoded)
        }
    }
}
