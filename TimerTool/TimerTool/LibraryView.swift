//
//  LibraryView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        let intervalSequenceList: [IntervalSequence] = SharedIntervalManager().loadIntervals()
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(intervalSequenceList) { sequence in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sequence \(sequence.name):")
                            .font(.headline)
                        ForEach(sequence.sequence.indices, id: \.self) { intervalIndex in
                            let interval = sequence.sequence[intervalIndex]
                            Text("Interval \(intervalIndex + 1): \(interval.lengthInSeconds)s — \(interval.isRest ? "Rest" : "Work")")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LibraryView()
}
