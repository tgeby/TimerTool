//
//  ExerciseView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI

struct ExerciseSelectorView: View {
    
    @ObservedObject var viewModel: IntervalViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(viewModel.sequences) { sequence in
                        NavigationLink(destination: UseTimerView(selectedSequence: sequence)) {
                            Text(sequence.name)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExerciseSelectorView(viewModel: IntervalViewModel())
}
