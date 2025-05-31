//
//  ContentView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    NavigationLink(destination: LibraryView()) {
                        Text("Show stored interval sequences")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
