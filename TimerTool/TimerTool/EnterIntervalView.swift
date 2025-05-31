//
//  EnterIntervalView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//

import SwiftUI

struct EnterIntervalView: View {
    
    @State private var intervals: [Interval] = []
    @State private var newIntervalLength: String = ""
    @State private var newIntervalIsRest: Bool = false
    @State private var storedIntervals: [[Interval]] = []
    @State private var showStoredInterval: Bool = false
    
    func addIntervalButton() {
        if let seconds = Int(newIntervalLength), seconds > 0 {
            let newInterval = Interval(lengthInSeconds: seconds, isRest: newIntervalIsRest)
            intervals.append(newInterval)
            newIntervalLength = "" // Clear input
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Input for new interval length
            Spacer()
            HStack {
                TextField("Seconds", text: $newIntervalLength)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Toggle("Is Rest Interval", isOn: $newIntervalIsRest)
                    .font(.caption)
                Button(action: {
                    addIntervalButton()
                    newIntervalIsRest = false
                    }) {
                    Text("Add Interval")
                }
            }
            // List of intervals
            List(intervals) { interval in
                HStack{
                    Text("Interval: \(interval.lengthInSeconds) seconds")
                    Spacer()
                    if interval.isRest {
                        Text("Rest set")
                    } else {
                        Text("Work set")
                    }
                }
            }
            Button (action: {
                SharedIntervalManager.shared.appendIntervalSequence(intervals)
                intervals = []
            }) {
                Text("Submit")
            }
            Spacer()
//            Button (action: {
//                storedIntervals = SharedIntervalManager.shared.loadIntervals()
//                showStoredInterval = true
//            }) {
//                Text("Print stored interval")
//            }
//            if showStoredInterval {
//                List(storedIntervals[0]) { interval in
//                    HStack{
//                        Text("Interval: \(interval.lengthInSeconds) seconds")
//                        Spacer()
//                        if interval.isRest {
//                            Text("Rest set")
//                        } else {
//                            Text("Work set")
//                        }
//                    }
//                }
//            } else {
//                Text("No stored interval to display now")
//            }
        }
        .padding()
    }
}

#Preview {
    EnterIntervalView()
}
