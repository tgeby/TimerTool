//
//  TimerView.swift
//  TimerTool
//
//  Created by Thomas Eby on 6/3/25.
//
//
//  RefactoredTimerView.swift
//  TimerTool Watch App
//

import SwiftUI
import WatchKit

struct TimerView: View {
    let sequence: IntervalSequence
    @StateObject private var timerManager = TimerStateManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            if timerManager.currentState != .completed {
                VStack(spacing: 2) {
                    // Header
                    headerView
                    // Main timer display
                    timerDisplayView
                    // Progress indicators
                    progressView
                    // Control buttons
                    controlButtonsView
                }
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                Text("Timer complete!")
            }
        }
        .navigationBarBackButtonHidden(timerManager.currentState == .running)
        .onAppear {
            if timerManager.currentState == .idle {
                timerManager.setupNewSequence(sequence)
            }
        }
        .onDisappear {
            if timerManager.currentState != .completed {
                timerManager.stopTimer()
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack(spacing: 2) {
            Text(sequence.name)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            if timerManager.currentInterval != nil {
                Text(": \(timerManager.currentIntervalIndex + 1)/\(sequence.sequence.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
            }
        }
        .frame(maxHeight: 25)
    }
    
    private var timerDisplayView: some View {
        VStack(spacing: 2) {
            // Time remaining
            Text(formatTime(timerManager.timeRemaining))
                .font(.title2)
                .foregroundColor(timerManager.currentInterval?.isRest == true ? .blue : .green)
            
            // Interval type
            if let currentInterval = timerManager.currentInterval {
                Text(currentInterval.isRest ? "REST" : "WORK")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(currentInterval.isRest ? .blue : .green)
            }
        }
        .frame(maxHeight: 40)

    }
    
    private var progressView: some View {
        Group {
            // Total sequence progress
            ProgressView(value: timerManager.totalProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .frame(height: 2)
                .padding(.horizontal, 20)
        }
        .frame(maxHeight: 25)
    }
    
    private var controlButtonsView: some View {
        // Main control button
        Button(action: mainButtonAction) {
            HStack {
                Image(systemName: mainButtonIcon)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 50, maxWidth: .infinity)
            .frame(height: 35)
            .background(mainButtonColor)
            .cornerRadius(15)
            .contentShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 50)
    }
    
    // MARK: - Computed Properties
    
    private var mainButtonIcon: String {
        switch timerManager.currentState {
        case .idle, .completed:
            return "play.fill"
        case .running:
            return "pause.fill"
        case .paused:
            return "play.fill"
        }
    }
    
    private var mainButtonColor: Color {
        switch timerManager.currentState {
        case .idle, .completed:
            return .green
        case .running:
            return .orange
        case .paused:
            return .green
        }
    }
    
    // MARK: - Actions
    
    private func mainButtonAction() {
        switch timerManager.currentState {
        case .idle, .completed:
            timerManager.startTimer(with: sequence)
        case .running:
            timerManager.pauseTimer()
        case .paused:
            timerManager.resumeTimer()
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Preview

#Preview {
    TimerView(sequence: IntervalSequence(
        sequence: [
            Interval(lengthInSeconds: 30, isRest: false),
            Interval(lengthInSeconds: 10, isRest: true),
            Interval(lengthInSeconds: 30, isRest: false)
        ],
        name: "Sample Workout"
    ))
}
