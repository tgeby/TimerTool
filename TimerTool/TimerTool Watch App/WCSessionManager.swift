//
//  WCSessionManager.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//
import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    
    static let shared = WCSessionManager()
    
    @Published var lastMessage: String = ""
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendMessageToPhone(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return
        }
        guard WCSession.default.isReachable else {
            print("Counterpart not reachable, consider using updateApplicationContext")
            return
        }
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message to iPhone: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let message = message["message"] as? String {
                print("Received message: \(message)")
                // Update UI or take action
                self.lastMessage = message
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        }
    }
}

