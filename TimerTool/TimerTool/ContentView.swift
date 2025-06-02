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
        NavigationView {
            VStack {
                NavigationLink(destination: EnterIntervalView(viewModel: viewModel)) {
                    Label("Create a new interval sequence", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: LibraryView(viewModel: viewModel)) {
                    Label("Manage interval sequences", systemImage: "books.vertical")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("TimerTool")
        }
    }
}

#Preview {
    ContentView(viewModel: IntervalViewModel())
}
