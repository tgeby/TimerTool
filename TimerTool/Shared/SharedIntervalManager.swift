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

struct IntervalSequence: Identifiable, Codable {
    let id: UUID
    let sequence: [Interval]
    let name: String
    
    init(id: UUID = UUID(), sequence: [Interval], name: String) {
        self.id = id
        self.sequence = sequence
        self.name = name
    }
}

class SharedIntervalManager {
    static let shared = SharedIntervalManager()
    
    let suiteName = "group.teabee.TimerTool"
    let key = "savedIntervals"
    
    private var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    func saveIntervalSequences(_ intervalSequences: [IntervalSequence]) {
        if let encoded = try? JSONEncoder().encode(intervalSequences) {
            defaults?.set(encoded, forKey: key)
        }
    }
    
    func loadIntervals() -> [IntervalSequence] {
        guard let data = defaults?.data(forKey: key),
              let decoded = try? JSONDecoder().decode([IntervalSequence].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func appendIntervalSequence(_ intervalSequence: [Interval], _ name: String? = nil) {
        var allSequences: [IntervalSequence] = loadIntervals()
        let intervalSequence: IntervalSequence = IntervalSequence(sequence: intervalSequence, name: name ?? "")
        allSequences.append(intervalSequence)
        saveIntervalSequences(allSequences)
    }
}
