//
//  ExerciseView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI
import UIKit

struct ExerciseSelectorView: View {
    @ObservedObject var viewModel: IntervalViewModel
    
    var body: some View {
        VStack {
            if viewModel.sequences.isEmpty {
                emptyStateView
            } else {
                sequenceListView
            }
        }
        .navigationTitle("Select Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "timer.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No timer sequences")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Create sequences on your iPhone")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var sequenceListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.sequences) { sequence in
                    sequenceRow(for: sequence)
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func sequenceRow(for sequence: IntervalSequence) -> some View {
        let totalTime = calculateTotalTime(for: sequence)
        
        return NavigationLink(destination: TimerView(sequence: sequence)) {
            VStack(alignment: .leading, spacing: 10) {
                Text(sequence.name)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .lineLimit(2)
                
                Text("\(sequence.sequence.count) intervals")
                    .font(.caption)
                    .foregroundColor(Color.white)
                
                Text("Total: \(formatTime(totalTime))")
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            .padding()
            .frame(width: 150, alignment: .leading)
            .background(Color(red: 80/255, green: 200/255, blue: 120/255))
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func calculateTotalTime(for sequence: IntervalSequence) -> Int {
        return sequence.sequence.reduce(0) { $0 + $1.lengthInSeconds }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        if minutes > 0 {
            return "\(minutes)m \(remainingSeconds)s"
        } else {
            return "\(remainingSeconds)s"
        }
    }
}

#Preview {
    NavigationView {
        ExerciseSelectorView(viewModel: IntervalViewModel())
    }
}
