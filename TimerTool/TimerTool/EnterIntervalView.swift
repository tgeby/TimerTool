//
//  EnterIntervalView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/30/25.
//

import SwiftUI
import WatchConnectivity

struct EnterIntervalView: View {
    
    @State private var intervals: [Interval] = []
    @State private var newIntervalLength: String = ""
    @State private var newIntervalIsRest: Bool = false
    @State private var storedIntervals: [[Interval]] = []
//    @State private var showStoredInterval: Bool = false
    @State private var newIntervalName: String = ""
    
    func addIntervalButton() {
        if let seconds = Int(newIntervalLength), seconds > 0 {
            let newInterval = Interval(lengthInSeconds: seconds, isRest: newIntervalIsRest)
            intervals.append(newInterval)
            newIntervalLength = "" // Clear input
        }
    }
    
    func syncIntervalsToWatch() {
        let intervals = SharedIntervalManager.shared.loadIntervals()
        guard let data = try? JSONEncoder().encode(intervals) else { return }

        if WCSession.default.isReachable {
            // Instant message
            WCSession.default.sendMessage(["intervalsData": data], replyHandler: nil, errorHandler: nil)
        } else {
            // Queued for delivery
            WCSession.default.transferUserInfo(["intervalsData": data])
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Input for new interval length
            Spacer()
            TextField("Interval Sequence Name", text: $newIntervalName)
            HStack {
                TextField("Seconds", text: $newIntervalLength)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Toggle("Is Rest Interval", isOn: $newIntervalIsRest)
                    .font(.caption)
                Button(action: {
                    addIntervalButton()
                    newIntervalIsRest.toggle()
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
                SharedIntervalManager.shared.appendIntervalSequence(intervals, newIntervalName)
                intervals = []
                newIntervalName = ""
            }) {
                Text("Submit")
            }
            Spacer()
            Button (action: {
                syncIntervalsToWatch()
            }) {
                Text("Send to watch")
            }
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
