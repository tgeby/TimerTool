//
//  IntervalViewModel.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/31/25.
//

import Foundation
import WatchConnectivity
import Combine

class IntervalViewModel: ObservableObject {
    @Published var sequences: [IntervalSequence] = []

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSequences()
        
        WCSessionManager.shared.newDataReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadSequences()
            }
            .store(in: &cancellables)
    }

    func loadSequences() {
        sequences = SharedIntervalManager.shared.loadIntervals()
    }

    func addSequence(_ intervals: [Interval], name: String) {
        var current = SharedIntervalManager.shared.loadIntervals()
        let newSequence = IntervalSequence(sequence: intervals, name: name)
        current.append(newSequence)
        SharedIntervalManager.shared.saveIntervalSequences(current)
        self.sequences = current // Update published property
    }

    func syncToWatch() {
        let data = try? JSONEncoder().encode(sequences)
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["intervalsData": data ?? Data()], replyHandler: nil, errorHandler: nil)
        } else {
            WCSession.default.transferUserInfo(["intervalsData": data ?? Data()])
        }
    }
}
