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
        VStack {
            TextField("Sequence Name", text: $newIntervalName)
            HStack {
                TextField("Seconds", text: $newIntervalLength)
                    .keyboardType(.numberPad)
                    .frame(width: 80)
                Toggle("Rest?", isOn: $newIntervalIsRest)
                Button("Add") {
                    if let seconds = Int(newIntervalLength), seconds > 0 {
                        intervals.append(Interval(lengthInSeconds: seconds, isRest: newIntervalIsRest))
                        newIntervalLength = ""
                        newIntervalIsRest.toggle()
                    }
                }
            }

            List(intervals) { interval in
                Text("\(interval.lengthInSeconds)s \(interval.isRest ? "Rest" : "Work")")
            }

            Button("Submit") {
                viewModel.addSequence(intervals, name: newIntervalName)
                intervals.removeAll()
                newIntervalName = ""
            }

            Button("Send to Watch") {
                viewModel.syncToWatch()
            }

            List(viewModel.sequences) { seq in
                Text(seq.name)
            }
        }
        .padding()
    }
}

#Preview {
    EnterIntervalView(viewModel: IntervalViewModel())
}
