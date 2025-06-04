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
        GeometryReader { geometry in
            VStack(spacing: 8) {
                // Header
                headerView
                    .layoutPriority(1)
                
                // Main timer display
                timerDisplayView(geometry: geometry)
                    .layoutPriority(2)
                
                // Progress indicators
                progressView
                    .layoutPriority(1)
                
                // Control buttons
                controlButtonsView
                    .layoutPriority(1)
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        VStack(spacing: 2) {
            Text(sequence.name)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            if timerManager.currentInterval != nil {
                Text("\(timerManager.currentIntervalIndex + 1)/\(sequence.sequence.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
            }
        }
    }
    
    private func timerDisplayView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 4) {
            // Time remaining
            Text(formatTime(timerManager.timeRemaining))
                .font(.system(size: min(geometry.size.width * 0.2, 34), weight: .bold, design: .monospaced))
                .foregroundColor(timerManager.currentInterval?.isRest == true ? .blue : .green)
                .minimumScaleFactor(0.7)
            
            // Interval type
            if let currentInterval = timerManager.currentInterval {
                Text(currentInterval.isRest ? "REST" : "WORK")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(currentInterval.isRest ? .blue : .green)
            }
        }
    }
    
    private var progressView: some View {
        VStack(spacing: 4) {
            // Current interval progress
            ProgressView(value: timerManager.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: timerManager.currentInterval?.isRest == true ? .blue : .green))
                .frame(height: 4)
            
            // Total sequence progress
            ProgressView(value: timerManager.totalProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .frame(height: 2)
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 12) {
            // Stop button
            Button(action: {
                timerManager.stopTimer()
                dismiss()
            }) {
                Image(systemName: "stop.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(timerManager.currentState == .idle)
            
            Spacer()
            
            // Main control button
            Button(action: mainButtonAction) {
                Image(systemName: mainButtonIcon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .background(
                Circle()
                    .fill(mainButtonColor)
                    .frame(width: 50, height: 50)
            )
            
            Spacer()
            
            // Next interval button (when paused)
            if timerManager.currentState == .paused {
                Button(action: skipToNextInterval) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // Placeholder for spacing
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
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
    
    private func skipToNextInterval() {
        // This would require additional logic in TimerStateManager
        // For now, just resume the timer
        timerManager.resumeTimer()
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
