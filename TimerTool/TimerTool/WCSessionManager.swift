//
//  WCSessionManager.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//

import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate {
    static let shared = WCSessionManager()
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendMessageToWatch(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return
        }

        guard WCSession.default.isReachable else {
            print("Counterpart not reachable, consider using updateApplicationContext")
            return
        }
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message to watch: \(error.localizedDescription)")
        }
        print("Message sent!")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
}
