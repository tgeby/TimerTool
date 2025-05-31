//
//  LibraryView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        let intervalSequenceList: [[Interval]] = SharedIntervalManager().loadIntervals()
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(intervalSequenceList.enumerated()), id: \.offset) { (sequenceIndex, sequence) in
                    VStack(alignment: .leading) {
                        Text("Sequence \(sequenceIndex + 1):")
                            .font(.headline)
                        ForEach(sequence.indices, id: \.self) { intervalIndex in
                            let interval = sequence[intervalIndex]
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
