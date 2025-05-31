//
//  SharedIntervalManager.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//

import Foundation

struct Interval: Identifiable, Codable {
    let id: UUID
    let lengthInSeconds: Int
    let isRest: Bool

    init(id: UUID = UUID(), lengthInSeconds: Int, isRest: Bool) {
        self.id = id
        self.lengthInSeconds = lengthInSeconds
        self.isRest = isRest
    }
}

class SharedIntervalManager {
    static let shared = SharedIntervalManager()
    
    let suiteName = "group.teabee.TimerTool"
    let key = "savedIntervals"
    
    private var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    func saveIntervalSequences(_ intervalSequences: [[Interval]]) {
        if let encoded = try? JSONEncoder().encode(intervalSequences) {
            defaults?.set(encoded, forKey: key)
        }
    }
    
    func loadIntervals() -> [[Interval]] {
        guard let data = defaults?.data(forKey: key),
              let decoded = try? JSONDecoder().decode([[Interval]].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func appendIntervalSequence(_ intervalSequence: [Interval]) {
        var allSequences: [[Interval]] = loadIntervals()
        allSequences.append(intervalSequence)
        saveIntervalSequences(allSequences)
    }
}
