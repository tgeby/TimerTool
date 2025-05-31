//
//  UseTimerView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/31/25.
//

import SwiftUI

struct UseTimerView: View {
    
    @ObservedObject var viewModel: IntervalViewModel
    
    var selectedSequenceName: String
    var body: some View {
        Text("Hello from UseTimerView! We received the sequence name: \(selectedSequenceName)")
    }
}

#Preview {
    UseTimerView(viewModel: IntervalViewModel(), selectedSequenceName: "")
}
