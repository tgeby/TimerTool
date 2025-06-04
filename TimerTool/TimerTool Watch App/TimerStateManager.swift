//
//  T.swift
//  TimerTool
//
//  Created by Thomas Eby on 6/3/25.
//
//
//  TimerStateManager.swift
//  TimerTool Watch App
//

import Foundation
import SwiftUI
import WatchKit
import Combine

enum TimerState {
    case idle
    case running
    case paused
    case completed
}

class TimerStateManager: ObservableObject {
    @Published var currentState: TimerState = .idle
    @Published var currentIntervalIndex: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var totalElapsedTime: Int = 0
    @Published var currentSequence: IntervalSequence?
    
    private var timer: Timer?
    private var startTime: Date?
    private var pausedDuration: TimeInterval = 0
    
    // MARK: - Timer Control
    
    func startTimer(with sequence: IntervalSequence) {
        guard currentState == .idle || currentState == .paused else { return }
        
        if currentState == .idle {
            setupNewSequence(sequence)
        }
        
        currentState = .running
        startTime = Date()
        
        // Enable background processing
        BackgroundTimerManager.shared.enableBackgroundMode(for: .functionalStrengthTraining)
        
        // Schedule backup notifications
        if let sequence = currentSequence {
            BackgroundTimerManager.shared.scheduleIntervalNotifications(for: sequence, startTime: Date())
        }
        
        startInternalTimer()
    }
    
    func pauseTimer() {
        guard currentState == .running else { return }
        
        currentState = .paused
        stopInternalTimer()
        
        // Calculate paused duration
        if let start = startTime {
            pausedDuration += Date().timeIntervalSince(start)
        }
        startTime = nil
    }
    
    func resumeTimer() {
        guard currentState == .paused else { return }
        startTimer(with: currentSequence!)
    }
    
    func stopTimer() {
        currentState = .idle
        stopInternalTimer()
        resetTimerState()
        
        // Disable background processing
        BackgroundTimerManager.shared.disableBackgroundMode()
        BackgroundTimerManager.shared.clearScheduledNotifications()
    }
    
    func completeTimer() {
        currentState = .completed
        stopInternalTimer()
        
        // Provide completion feedback
        WKInterfaceDevice.current().play(.success)
        
        // Disable background processing
        BackgroundTimerManager.shared.disableBackgroundMode()
        BackgroundTimerManager.shared.clearScheduledNotifications()
    }
    
    func setupNewSequence(_ sequence: IntervalSequence) {
        currentSequence = sequence
        currentIntervalIndex = 0
        totalElapsedTime = 0
        pausedDuration = 0
        
        if let firstInterval = sequence.sequence.first {
            timeRemaining = firstInterval.lengthInSeconds
        }
    }
    
    // MARK: - Private Methods
    
    private func startInternalTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func stopInternalTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer() {
        guard let sequence = currentSequence,
              let start = startTime,
              currentIntervalIndex < sequence.sequence.count else { return }
        
        let currentInterval = sequence.sequence[currentIntervalIndex]
        let elapsed = pausedDuration + Date().timeIntervalSince(start)
        let remaining = TimeInterval(currentInterval.lengthInSeconds) - elapsed
        
        if remaining > 0 {
            timeRemaining = max(0, Int(ceil(remaining)))
            totalElapsedTime = Int(pausedDuration + Date().timeIntervalSince(start))
        } else {
            // Interval completed
            handleIntervalCompletion(sequence: sequence)
        }
    }
    
    private func handleIntervalCompletion(sequence: IntervalSequence) {
        // Provide haptic feedback
        WKInterfaceDevice.current().play(.notification)
        
        if currentIntervalIndex < sequence.sequence.count - 1 {
            // Move to next interval
            currentIntervalIndex += 1
            pausedDuration = 0
            startTime = Date()
            timeRemaining = sequence.sequence[currentIntervalIndex].lengthInSeconds
        } else {
            // Sequence completed
            completeTimer()
        }
    }
    
    private func resetTimerState() {
        currentIntervalIndex = 0
        timeRemaining = 0
        totalElapsedTime = 0
        startTime = nil
        pausedDuration = 0
        currentSequence = nil
    }
    
    // MARK: - Computed Properties
    
    var currentInterval: Interval? {
        guard let sequence = currentSequence,
              currentIntervalIndex < sequence.sequence.count else { return nil }
        return sequence.sequence[currentIntervalIndex]
    }
    
    var progress: Double {
        guard let interval = currentInterval else { return 0 }
        let elapsed = Double(interval.lengthInSeconds - timeRemaining)
        return elapsed / Double(interval.lengthInSeconds)
    }
    
    var totalProgress: Double {
        guard let sequence = currentSequence else { return 0 }
        let totalTime = sequence.sequence.reduce(0) { $0 + $1.lengthInSeconds }
        return Double(totalElapsedTime) / Double(totalTime)
    }
}
