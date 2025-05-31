//
//  ContentView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: IntervalViewModel
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text("Options")
                        .fontWeight(.medium)
                        .font(.system(size: 50))
                            .dynamicTypeSize(.medium ... .xxLarge)
                        .padding()
                    NavigationLink(destination: EnterIntervalView(viewModel: viewModel)) {
                        Text("Create a new interval sequence")
                            .padding()
                    }
                    NavigationLink(destination: LibraryView(viewModel: viewModel)) {
                        Text("Manage interval sequences")
                            .padding()
                    }
//                    NavigationLink(destination: TestView()) {
//                        Text("Test view")
//                            .padding()
//                    }
                }
            }
            Spacer().frame(height: 200)
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: IntervalViewModel())
}
