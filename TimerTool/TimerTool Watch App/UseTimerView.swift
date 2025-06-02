//
//  UseTimerView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI
import HealthKit

struct UseTimerView: View {
    
    
    @State var selectedSequence: IntervalSequence
    @State var isRunning: Bool = false
    @State var currentInterval = 0
    @State var startTime: Date? = nil
    @State var timeRemaining = 0
    @State var pausedTime: Int = 0
    @StateObject var workoutManager = WorkoutManager()
    
    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let intervalList = selectedSequence.sequence
        VStack {
            Text("Hello from UseTimerView! We received the sequence name: \(selectedSequence.name)")
            Text("Set \(currentInterval + 1) out of \(intervalList.count) intervals")
            Text("Time remaining: \(timeRemaining)")
            Button(isRunning ? "Stop" : "Start") {
                if isRunning {
                    // pause
                    if let start = startTime {
                        pausedTime += Int(Date().timeIntervalSince(start))
                    }
                    isRunning = false
                    startTime = nil
                } else {
                    // resume or start
                    if currentInterval >= intervalList.count {
                        currentInterval = 0
                    } else {
                        if !intervalList.isEmpty {
                            startTime = Date()
                            isRunning = true
                        }
                    }
                }
            }
            Button("Reset") {
                isRunning = false
                currentInterval = 0
                pausedTime = 0
                startTime = nil
                if !intervalList.isEmpty {
                    timeRemaining = intervalList[0].lengthInSeconds
                } else {
                    timeRemaining = 0
                }
            }
        }
        .onAppear {
            if let first = intervalList.first {
                timeRemaining = first.lengthInSeconds
            }
            workoutManager.startWorkout()
        }
        .onDisappear {
            workoutManager.stopWorkout()
        }
        .onReceive(timer) { now in
            guard isRunning,
                  currentInterval < intervalList.count,
                  let start = startTime else { return }

            let currentIntervalLength = intervalList[currentInterval].lengthInSeconds
            let elapsed = pausedTime + Int(now.timeIntervalSince(start))
            let remaining = currentIntervalLength - elapsed

            if remaining > 0 {
                timeRemaining = remaining
            } else {
                WKInterfaceDevice.current().play(.notification)
                if currentInterval < intervalList.count - 1 {
                    currentInterval += 1
                    pausedTime = 0
                    startTime = Date()
                    timeRemaining = intervalList[currentInterval].lengthInSeconds
                } else {
                    isRunning = false
                    startTime = nil
                    pausedTime = 0
                }
            }
        }
    }
}

#Preview {
    UseTimerView(selectedSequence: IntervalSequence(sequence: [], name: "name"))
}
