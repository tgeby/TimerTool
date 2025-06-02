//
//  EnterIntervalView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//

import SwiftUI
import WatchConnectivity

struct EnterIntervalView: View {
    @ObservedObject var viewModel: IntervalViewModel
    @State private var intervals: [Interval] = []
    @State private var newIntervalLength: String = ""
    @State private var newIntervalIsRest: Bool = false
    @State private var newIntervalName: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Create New Sequence")
                        .font(.headline)
                    TextField("Sequence Name", text: $newIntervalName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        TextField("Seconds", text: $newIntervalLength)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Toggle("Rest?", isOn: $newIntervalIsRest)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Button(action: addInterval) {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                        .disabled(newIntervalLength.isEmpty)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                if !intervals.isEmpty {
                    VStack(alignment: .leading) {
                        Text("New Intervals")
                            .font(.headline)
                        ForEach(intervals) { interval in
                            HStack {
                                Text("\(interval.lengthInSeconds)s")
                                Spacer()
                                Text(interval.isRest ? "Rest" : "Work")
                                    .foregroundColor(interval.isRest ? .blue : .green)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                VStack (spacing: 10) {
                    Button(action: submitSequence) {
                        Label("Submit Sequence", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: viewModel.syncToWatch) {
                        Label("Send to Watch", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Saved sequences")
                        .font(.headline)
                    ForEach(viewModel.sequences) { seq in
                        Text(seq.name)
                            .font(.body)
                            .padding(.vertical, 2)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Enter Intervals")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addInterval() {
        if let seconds = Int(newIntervalLength), seconds > 0 {
            intervals.append(Interval(lengthInSeconds: seconds, isRest: newIntervalIsRest))
            newIntervalLength = ""
            newIntervalIsRest.toggle()
        }
    }
    
    private func submitSequence() {
        guard !newIntervalName.isEmpty else { return }
        viewModel.addSequence(intervals, name: newIntervalName)
        intervals.removeAll()
        newIntervalName = ""
    }
}

#Preview {
    EnterIntervalView(viewModel: IntervalViewModel())
}
